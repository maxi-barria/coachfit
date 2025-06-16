import { prisma } from '../prisma/client'

export const getExerciseHistory = async (
  exerciseId: string,
  userId: string,
) => {
  const sets = await prisma.setSession.findMany({
    where: {
      workoutExercise: {
        exerciseId,
        workout: {
          userId,
        },
      },
    },
    include: {
      workoutSession: {
        select: {
          startedAt: true,
          workout: {
            select: { name: true },
          },
        },
      },
      intensityIndicator: true,
    },
    orderBy: { createdAt: 'asc' },
  })

  return sets.map((set) => ({
    date: set.workoutSession.startedAt,
    weight: set.weight,
    reps: set.rep,
    restSeconds: set.restSeconds,
    intensity: set.intensityIndicator?.value ?? null,
    workoutName: set.workoutSession.workout.name,
  }))
}
