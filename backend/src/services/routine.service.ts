/* =========================================================================
 *  services/routine.service.ts
 *  CRUD de rutinas, workouts, ejercicios y sets
 * ========================================================================= */

import { prisma } from '../prisma/client';
import {
  CreateRoutineInput,
  UpdateRoutineInput,
  CreateWorkoutInput,
  AddSetInput,
  AddExerciseInput,
} from '../validators/routine.validator';
import { Prisma } from '@prisma/client';

/* ========================= CREAR RUTINA ========================= */
export const createRoutine = async (
  userId: string,
  data: CreateRoutineInput,
) => {
  return prisma.$transaction(async (tx) => {
    /* objeto sin undefined */
    const routineData: Prisma.RoutineUncheckedCreateInput = {
      userId,
      name   : data.name,
      goal   : data.goal ?? '',
      editable: true,
      version : 1,
      startDate: data.startDate ? new Date(data.startDate) : new Date(),
      endDate: data.endDate ? new Date(data.endDate) : new Date(),
    };
    if (data.startDate) routineData.startDate = new Date(data.startDate);
    if (data.endDate)   routineData.endDate   = new Date(data.endDate);

    const routine = await tx.routine.create({ data: routineData });

    /* workouts anidados (opcional) */
    if (data.workouts?.length) {
      for (const [i, w] of data.workouts.entries()) {
        const workout = await tx.workout.create({
          data: {
            userId,
            name : w.name,
            date : new Date(w.date),
            secondsDuration: w.secondsDuration ?? null,
            note : w.note ?? null,
            workoutExercises: {
              create: w.exercises.map((ex, idx) => ({
                orden   : ex.orden ?? idx + 1,
                exercise: { connect: { id: ex.exerciseId } },
                sets: {
                  create: ex.sets.map((s) => ({
                    repetition: s.repetition,
                    weight    : s.weight,
                    restSeconds: s.restSeconds,
                    note      : s.note,
                    intensityIndicatorId: s.intensityIndicatorId ?? null,
                  })),
                },
              })),
            },
          },
        });

        await tx.routineWorkout.create({
          data: { routineId: routine.id, workoutId: workout.id, orden: i + 1 },
        });
      }
    }

    return routine;
  });
};

/* ====================== LISTAR / OBTENER ======================= */
export const listRoutines = (userId: string) =>
  prisma.routine.findMany({
    where : { userId },
    orderBy: { createdAt: 'desc' },
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

export const getRoutine = (id: string, userId: string) =>
  prisma.routine.findFirst({
    where : { id, userId },
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

/* =========================== UPDATE ============================ */
export const updateRoutine = async (
  id: string,
  data: UpdateRoutineInput,
  userId: string,
) => {
  const routine = await prisma.routine.findFirst({ where: { id, userId } });
  if (!routine)          return { status: 404 };
  if (!routine.editable) return { status: 403, message: 'Routine is locked' };

  const updateData: Prisma.RoutineUncheckedUpdateInput = {
    version: routine.version + 1,
  };
  if (data.name)       updateData.name = data.name;
  if (data.goal !== undefined) updateData.goal = data.goal;
  if (data.startDate)  updateData.startDate = new Date(data.startDate);
  if (data.endDate)    updateData.endDate   = new Date(data.endDate);

  await prisma.routine.update({ where: { id }, data: updateData });
  return { status: 200 };
};

/* =========================== DELETE ============================ */
export const deleteRoutine = (id: string, userId: string) =>
  prisma.routine.deleteMany({ where: { id, userId } });

/* ====================== CREAR WORKOUT ========================== */
export const createWorkout = async (
  routineId: string,
  data: CreateWorkoutInput,
  userId: string,
) => {
  const routine = await prisma.routine.findFirst({ where: { id: routineId, userId } });
  if (!routine) return { status: 404, message: 'Routine not found' };

  const workout = await prisma.workout.create({
    data: {
      userId,
      name : data.name,
      date : new Date(data.date),
      secondsDuration: data.secondsDuration ?? null,
      note : data.note ?? null,
      workoutExercises: {
        create: data.exercises.map((ex, idx) => ({
          orden   : ex.orden ?? idx + 1,
          exercise: { connect: { id: ex.exerciseId } },
          sets: {
            create: ex.sets.map((s) => ({
              repetition: s.repetition,
              weight    : s.weight,
              restSeconds: s.restSeconds,
              note      : s.note,
              intensityIndicatorId: s.intensityIndicatorId ?? null,
            })),
          },
        })),
      },
    },
  });

  const orden = await prisma.routineWorkout.count({ where: { routineId } });
  await prisma.routineWorkout.create({
    data: { routineId, workoutId: workout.id, orden: orden + 1 },
  });

  return { status: 201, data: workout };
};

/* ===================== AGREGAR EJERCICIO ======================= */
export const addExerciseToWorkout = async (
  workoutId: string,
  data: AddExerciseInput,
  userId: string,
) => {
  const workout = await prisma.workout.findFirst({
    where: { id: workoutId, userId },
  });
  if (!workout) return { status: 404, message: 'Workout not found' };

  const orden =
    data.orden ??
    (await prisma.workoutExercise.count({ where: { workoutId } })) + 1;

  const workoutExercise = await prisma.workoutExercise.create({
    data: {
      workoutId,
      exerciseId: data.exerciseId,
      orden,
      sets: {
        create: data.sets.map((s) => ({
          repetition: s.repetition,
          weight    : s.weight,
          restSeconds: s.restSeconds,
          note      : s.note,
          intensityIndicatorId: s.intensityIndicatorId ?? null,
        })),
      },
    },
    include: {
      exercise: true,
      sets    : true,
    },
  });

  return { status: 201, data: workoutExercise };
};

/* ===================== AGREGAR / QUITAR SET ==================== */
export const addSetToExercise = async (
  routineId: string,
  workoutId: string,
  exerciseId: string,
  set: AddSetInput['set'],
  userId: string,
) => {
  const routine = await prisma.routine.findFirst({
    where : { id: routineId, userId },
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
      weight    : set.weight,
      restSeconds: set.restSeconds,
      intensityIndicatorId: set.intensityIndicatorId ?? null,
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
    where : { id: setId },
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
    setObj.workoutExercise.workout.routineWorkouts[0]?.routine.id     !== routineId
  ) {
    return { status: 404, message: 'Set not found or not yours' };
  }

  await prisma.set.delete({ where: { id: setId } });
  return { status: 200 };
};
