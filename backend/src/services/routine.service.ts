import { prisma } from '../prisma/client';
import {
  CreateRoutineInput,
  UpdateRoutineInput,
  AddSetInput,
} from '../validators/routine.validator';

/* ------------------------- CRUD DE RUTINAS ------------------------- */

export const createRoutine = async (
  userId: string,
  data: CreateRoutineInput,
) => {
  return prisma.$transaction(async (tx) => {
    const routine = await tx.routine.create({
      data: {
        userId,
        name: data.name,
        goal: data.goal,
        startDate: new Date(data.startDate),
        endDate: new Date(data.endDate),
        editable: true,
        version: 1,
      },
    });

    if (data.workouts && data.workouts.length > 0) {
  for (const [i, workoutData] of data.workouts.entries()) {
    const workout = await tx.workout.create({
      data: {
        userId,
        name: workoutData.name,
        date: new Date(workoutData.date),
        secondsDuration: workoutData.secondsDuration ?? null,
        note: workoutData.note ?? null,
      },
    });

    await tx.routineWorkout.create({
      data: {
        routineId: routine.id,
        workoutId: workout.id,
        orden: i + 1,
      },
    });

    for (const [j, exData] of workoutData.exercises.entries()) {
      const workoutExercise = await tx.workoutExercise.create({
        data: {
          workoutId: workout.id,
          exerciseId: exData.exerciseId,
          orden: j + 1,
        },
      });

      for (const set of exData.sets) {
        await tx.set.create({
          data: {
            workoutExerciseId: workoutExercise.id,
            repetition: set.repetition,
            weight: set.weight,
            intensityIndicatorId: set.intensityIndicatorId ?? null,
            restSeconds: set.restSeconds,
          },
        });
      }
    }
  }
}

    return routine;
  });
};

export const listRoutines = async (userId: string) => {
  return prisma.routine.findMany({
    where: { userId },
    orderBy: { createdAt: 'desc' },
    select: {
      id: true,
      name: true,
      goal: true,
      startDate: true,
      endDate: true,
      version: true,
      editable: true,
    },
  });
};

export const getRoutine = async (id: string, userId: string) => {
  return prisma.routine.findFirst({
    where: { id, userId },
    include: {
      routineWorkouts: {
        orderBy: { orden: 'asc' },
        include: {
          workout: {
            include: {
              workoutExercises: {
                orderBy: { orden: 'asc' },
                include: {
                  exercise: true,
                  sets: { orderBy: { createdAt: 'asc' } },
                },
              },
            },
          },
        },
      },
    },
  });
};

export const updateRoutine = async (
  id: string,
  data: UpdateRoutineInput,
  userId: string,
) => {
  const routine = await prisma.routine.findFirst({
    where: { id, userId },
  });
  if (!routine) return { status: 404 };

  if (!routine.editable) return { status: 403, message: 'Routine is locked' };

  await prisma.routine.update({
    where: { id },
    data: {
      name: data.name ?? routine.name,
      goal: data.goal ?? routine.goal,
      startDate: data.startDate ? new Date(data.startDate) : routine.startDate,
      endDate: data.endDate ? new Date(data.endDate) : routine.endDate,
      version: routine.version + 1,
    },
  });

  return { status: 200 };
};

export const deleteRoutine = async (id: string, userId: string) => {
  return prisma.routine.deleteMany({
    where: { id, userId },
  });
};

/* -------------------- AGREGAR / QUITAR SETS -------------------- */

export const addSetToExercise = async (
  routineId: string,
  workoutId: string,
  exerciseId: string,
  set: AddSetInput['set'],
  userId: string,
) => {
  const routine = await prisma.routine.findFirst({
    where: { id: routineId, userId },
    include: { routineWorkouts: { where: { workoutId } } },
  });
  if (!routine) return { status: 404, message: 'Routine/workout not found' };

  const wEx = await prisma.workoutExercise.findFirst({
    where: { workoutId, exerciseId },
  });
  if (!wEx) return { status: 404, message: 'Exercise not in workout' };

  const newSet = await prisma.set.create({
    data: {
      workoutExerciseId: wEx.id,
      repetition: set.repetition,
      weight: set.weight,
      intensityIndicatorId: set.intensityIndicatorId ?? null,
      restSeconds: set.restSeconds,
    },
  });

  return { status: 201, data: newSet };
};

export const removeSetFromExercise = async (
  routineId: string,
  setId: string,
  userId: string,
) => {
  const setObj = await prisma.set.findUnique({
    where: { id: setId },
    include: {
      workoutExercise: {
        include: {
          workout: {
            include: {
              routineWorkouts: { include: { routine: true } },
            },
          },
        },
      },
    },
  });

  if (
    !setObj ||
    setObj.workoutExercise.workout.routineWorkouts[0]?.routine.userId !== userId ||
    setObj.workoutExercise.workout.routineWorkouts[0]?.routine.id !== routineId
  ) {
    return { status: 404, message: 'Set not found or not yours' };
  }

  await prisma.set.delete({ where: { id: setId } });
  return { status: 200 };
};
