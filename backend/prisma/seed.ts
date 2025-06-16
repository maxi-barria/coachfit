/* prisma/seed.ts ------------------------------------------------------- */
import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

async function main() {
  /* 1. Limpieza rápida -------------------------------------------------- */
  await prisma.$transaction([
    prisma.workoutSessionSummary.deleteMany(),
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
      password: '$2b$10$n9J4GMeY2t2D2w/4P4rawOlpSwnP7V9DQL6Jr9FtB5Bqi48c9bq4e',
      rol: 'cliente',
    },
  })

  /* 3. Músculos y porciones -------------------------------------------- */
  const musclesData = [
    { name: 'Pecho', portions: ['Pectoral mayor', 'Pectoral menor'] },
    { name: 'Espalda', portions: ['Dorsal ancho', 'Trapecio'] },
    { name: 'Pierna', portions: ['Cuádriceps', 'Isquiotibiales'] },
  ]

  for (const m of musclesData) {
    const muscle = await prisma.muscle.create({ data: { name: m.name } })
    await prisma.musclePortion.createMany({
      data: m.portions.map(p => ({ name: p, muscleId: muscle.id })),
    })
  }
  console.log('Músculos y porciones creados')

  /* 4. Ejercicios globales --------------------------------------------- */
  await prisma.exercise.createMany({
    data: [
      { name: 'Push-up', type: 'bodyweight', isCustom: false },
      { name: 'Pull-up', type: 'bodyweight', isCustom: false },
      { name: 'Squat', type: 'bodyweight', isCustom: false },
    ],
  })

  /* 4b. Vincular ejercicios ↔ porciones -------------------------------- */
  const exercises = await prisma.exercise.findMany({ select: { id: true, name: true } })
  const exerciseMap = Object.fromEntries(exercises.map(e => [e.name, e.id]))

  const portions = await prisma.musclePortion.findMany()
  const portionId = (n: string) => portions.find(p => p.name === n)!.id

  await prisma.exerciseMusclePortion.createMany({
    data: [
      { exerciseId: exerciseMap['Push-up'], musclePortionId: portionId('Pectoral mayor'), estimatedPercentage: 70 },
      { exerciseId: exerciseMap['Push-up'], musclePortionId: portionId('Pectoral menor'), estimatedPercentage: 30 },
      { exerciseId: exerciseMap['Pull-up'], musclePortionId: portionId('Dorsal ancho'), estimatedPercentage: 80 },
      { exerciseId: exerciseMap['Squat'], musclePortionId: portionId('Cuádriceps'), estimatedPercentage: 70 },
      { exerciseId: exerciseMap['Squat'], musclePortionId: portionId('Isquiotibiales'), estimatedPercentage: 30 },
    ],
    skipDuplicates: true,
  })

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
    data: { workoutId: workout.id, exerciseId: pushUp.id, orden: 1 },
  })

  await prisma.set.createMany({
    data: [
      { workoutExerciseId: wExercise.id, repetition: 12, weight: 0, restSeconds: 60, intensityIndicatorId: rpe8!.id },
      { workoutExerciseId: wExercise.id, repetition: 15, weight: 0, restSeconds: 90, intensityIndicatorId: rpe8!.id },
    ],
  })

  /* 8. Múltiples sesiones con progreso ---------------------------------- */
  const now = Date.now();
  const sessions = [];

  for (let i = 0; i < 5; i++) {
    const start = new Date(now - i * 3 * 86400000); // cada 3 días hacia atrás
    const end = new Date(start.getTime() + 3500 * 1000);

    const session = await prisma.workoutSession.create({
      data: {
        userId: user.id,
        workoutId: workout.id,
        startedAt: start,
        endedAt: end,
        secondsDuration: 3500,
        comment: `Sesión del ${start.toDateString()}`,
      },
    });

    const setsData = [
      {
        workoutSessionId: session.id,
        workoutExerciseId: wExercise.id,
        rep: 10 + i,
        weight: 10 * i,
        restSeconds: 60,
        intensityIndicatorId: rpe8!.id,
      },
      {
        workoutSessionId: session.id,
        workoutExerciseId: wExercise.id,
        rep: 12 + i,
        weight: 10 * i,
        restSeconds: 90,
        intensityIndicatorId: rpe8!.id,
      },
    ];

    await prisma.setSession.createMany({ data: setsData });

    await prisma.workoutSessionSummary.create({
      data: {
        workoutSessionId: session.id,
        totalSets: setsData.length,
        totalReps: setsData.reduce((a, b) => a + b.rep, 0),
        totalVolume: setsData.reduce((a, b) => a + b.rep * b.weight, 0),
      },
    });

    sessions.push(session);
  }

  console.log('Historial de sesiones creado');

  /* 9. Usuarios adicionales (Coach y Cliente) ---------------------------- */
  const coach = await prisma.user.create({
    data: {
      email: 'coach@example.com',
      password: '$2b$10$n9J4GMeY2t2D2w/4P4rawOlpSwnP7V9DQL6Jr9FtB5Bqi48c9bq4e',
      rol: 'coach',
    },
  });

  const client = await prisma.user.create({
    data: {
      email: 'cliente@example.com',
      password: '$2b$10$n9J4GMeY2t2D2w/4P4rawOlpSwnP7V9DQL6Jr9FtB5Bqi48c9bq4e',
      rol: 'cliente',
    },
  });

  /* 10. Relación Coach ↔ Cliente ---------------------------------------- */
  const coachClient = await prisma.coachClient.create({
    data: {
      coachId: coach.id,
      clientId: client.id,
      note: 'Cliente motivado, trabajar enfoque en técnica.',
      startDate: new Date(Date.now() - 5 * 86400000), // hace 5 días
    },
  });

  /* 11. Nota del coach al cliente ---------------------------------------- */
  await prisma.note.create({
    data: {
      coachId: coach.id,
      userId: client.id,
      content: 'Hoy progresó bastante en la sentadilla.',
    },
  });

  /* 12. Estados de invitación y ejemplo ---------------------------------- */
  const statePending = await prisma.state.create({ data: { value: 'pending' } });
  const stateAccepted = await prisma.state.create({ data: { value: 'accepted' } });

  await prisma.coachInvitation.create({
    data: {
      coachId: coach.id,
      emailClient: 'nuevo_cliente@example.com',
      token: 'token-de-ejemplo',
      expirationDate: new Date(Date.now() + 7 * 86400000), // vence en 7 días
      stateId: statePending.id,
    },
  });

  console.log('Relaciones coach-cliente creadas');


}

main()
  .then(async () => {
    console.log('Seed finalizado')
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })
