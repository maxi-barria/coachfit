/* prisma/seed.ts ------------------------------------------------------- */
import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

async function main() {
  /* 1. Limpieza rápida -------------------------------------------------- */
  await prisma.$transaction([
    prisma.setSession.deleteMany(),
    prisma.workoutSession.deleteMany(),
    prisma.set.deleteMany(),
    prisma.workoutExercise.deleteMany(),
    prisma.routineWorkout.deleteMany(),
    prisma.workout.deleteMany(),
    prisma.routine.deleteMany(),
    prisma.exerciseMusclePortion.deleteMany(),
    prisma.exercise.deleteMany(),
    prisma.musclePortion.deleteMany(),
    prisma.muscle.deleteMany(),
    prisma.intensityIndicator.deleteMany(),
    prisma.user.deleteMany(),
  ])
  console.log('Base limpiada')

  /* 2. Usuario demo ----------------------------------------------------- */
  const user = await prisma.user.upsert({
    where: { email: 'testuser@gmail.com' },
    update: {},
    create: {
      id: 'db2b0309-bcf7-4d59-be09-ca0a543e50ce',
      email: 'testuser@gmail.com',
      password: '$2b$10$n9J4GMeY2t2D2w/4P4rawOlpSwnP7V9DQL6Jr9FtB5Bqi48c9bq4e', // hash demo
      rol: 'cliente',
    },
  })

  /* 3. Músculos y porciones -------------------------------------------- */
  const musclesData = [
    { name: 'Pecho',   portions: ['Pectoral mayor', 'Pectoral menor'] },
    { name: 'Espalda', portions: ['Dorsal ancho', 'Trapecio'] },
    { name: 'Pierna',  portions: ['Cuádriceps', 'Isquiotibiales'] },
  ]

  for (const m of musclesData) {
    const muscle = await prisma.muscle.create({ data: { name: m.name } })
    await prisma.musclePortion.createMany({
      data: m.portions.map((p) => ({ name: p, muscleId: muscle.id })),
    })
  }
  console.log('Músculos y porciones creados')

  /* 4. Ejercicios globales --------------------------------------------- */
  await prisma.exercise.createMany({
    data: [
      { name: 'Push-up', type: 'bodyweight', isCustom: false },
      { name: 'Pull-up', type: 'bodyweight', isCustom: false },
      { name: 'Squat',   type: 'bodyweight', isCustom: false },
    ],
  })

  /* 4 b. Vincular ejercicios ↔ porciones ------------------------------- */
  const exercises = await prisma.exercise.findMany({ select: { id: true, name: true } })
  const exerciseMap = Object.fromEntries(exercises.map(({ id, name }) => [name, id]))

  const portions = await prisma.musclePortion.findMany()
  const portionId = (name: string) => portions.find(p => p.name === name)!.id

  await prisma.exerciseMusclePortion.createMany({
    data: [
      { exerciseId: exerciseMap['Push-up'], musclePortionId: portionId('Pectoral mayor'),  estimatedPercentage: 70 },
      { exerciseId: exerciseMap['Push-up'], musclePortionId: portionId('Pectoral menor'),  estimatedPercentage: 30 },
      { exerciseId: exerciseMap['Pull-up'], musclePortionId: portionId('Dorsal ancho'),    estimatedPercentage: 80 },
      { exerciseId: exerciseMap['Squat'],   musclePortionId: portionId('Cuádriceps'),      estimatedPercentage: 70 },
      { exerciseId: exerciseMap['Squat'],   musclePortionId: portionId('Isquiotibiales'),  estimatedPercentage: 30 },
    ],
    skipDuplicates: true,
  })
  console.log('Ejercicios vinculados a porciones')

  /* 5. Indicadores de intensidad --------------------------------------- */
  await prisma.intensityIndicator.createMany({
    data: [
      { name: 'RPE', value: '6', description: 'Esfuerzo percibido 6/10' },
      { name: 'RPE', value: '8', description: 'Esfuerzo percibido 8/10' },
    ],
  })
  const rpe8 = await prisma.intensityIndicator.findFirst({ where: { name: 'RPE', value: '8' } })

  /* 6. Rutina y workout de muestra ------------------------------------- */
  const routine = await prisma.routine.create({
    data: {
      userId: user.id,
      name: 'Rutina semanal',
      goal: 'Hipertrofia y fuerza',
      startDate: new Date(),
      endDate: new Date(Date.now() + 30 * 86400_000),
      editable: true,
      version: 1,
    },
  })

  const workout = await prisma.workout.create({
    data: {
      userId: user.id,
      name: 'Día 1 – Pecho y Espalda',
      date: new Date(),
      secondsDuration: 3600,
    },
  })

  await prisma.routineWorkout.create({
    data: { routineId: routine.id, workoutId: workout.id, orden: 1 },
  })

  /* 7. Ejercicio dentro del workout ------------------------------------ */
  const pushUp = exercises.find(e => e.name === 'Push-up')!
  const wExercise = await prisma.workoutExercise.create({
    data: {
      workoutId: workout.id,
      exerciseId: pushUp.id,
      orden: 1,
    },
  })

  await prisma.set.createMany({
    data: [
      { workoutExerciseId: wExercise.id, repetition: 12, weight: 0, restSeconds: 60, intensityIndicatorId: rpe8!.id },
      { workoutExerciseId: wExercise.id, repetition: 15, weight: 0, restSeconds: 90, intensityIndicatorId: rpe8!.id },
    ],
  })

  /* 8. Sesión real de progreso ----------------------------------------- */
  const session = await prisma.workoutSession.create({
    data: {
      userId: user.id,
      workoutId: workout.id,
      secondsDuration: 3500,
      comment: 'Buenos resultados hoy 🚀',
    },
  })

  await prisma.setSession.createMany({
    data: [
      {
        workoutSessionId: session.id,
        workoutExerciseId: wExercise.id,
        rep: 12,
        weight: 0,
        restSeconds: 60,
        intensityIndicatorId: rpe8!.id,
      },
      {
        workoutSessionId: session.id,
        workoutExerciseId: wExercise.id,
        rep: 15,
        weight: 0,
        restSeconds: 90,
        intensityIndicatorId: rpe8!.id,
      },
    ],
  })

  console.log('Datos de progreso creados')
}

main()
  .then(() => {
    console.log('Seed finalizado')
    return prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })
