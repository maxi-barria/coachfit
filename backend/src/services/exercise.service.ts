
import { prisma } from '../prisma/client';
import {
  CreateExerciseInput,
  UpdateExerciseInput,
} from '../validators/exercise.validator';

/** Crea un ejercicio personalizado para el usuario */
export const createExercise = async (
  data: CreateExerciseInput,
  userId: string,
) => {
  return prisma.exercise.create({
    data: { ...data, user_id: userId, is_custom: true },
  });
};

/** Lista globales + propios */
export const listExercises = async (userId: string) => {
  return prisma.exercise.findMany({
    where: { OR: [{ user_id: null }, { user_id: userId }] },
  });
};

/** Devuelve un ejercicio global o propio */
export const getExercise = async (id: string, userId: string) => {
  return prisma.exercise.findFirst({
    where: { id, OR: [{ user_id: null }, { user_id: userId }] },
  });
};

/** Actualiza (o clona y actualiza) un ejercicio */
export const updateExercise = async (
  id: string,
  data: UpdateExerciseInput,
  userId: string,
) => {
  const existing = await prisma.exercise.findUnique({ where: { id } });
  if (!existing) return { status: 404, message: 'Not found' };

  /** Si es global, se clona y se actualiza la copia */
  if (!existing.user_id) {
    const copy = await prisma.exercise.create({
      data: {
        ...existing,
        ...data,
        id: undefined,      // nuevo ID autogenerado
        user_id: userId,
        is_custom: true,
      },
    });
    return { status: 201, data: copy }; // 201 Created (copia)
  }

  /** Si pertenece al usuario, se actualiza directamente */
  const updated = await prisma.exercise.updateMany({
    where: { id, user_id: userId },
    data,
  });

  if (updated.count === 0)
    return { status: 404, message: 'Not found or not yours' };

  return { status: 200 };
};

/** Elimina solo la versión del usuario (no toca los globales) */
export const deleteExercise = async (id: string, userId: string) => {
  const deleted = await prisma.exercise.deleteMany({
    where: { id, user_id: userId },
  });
  return deleted; // deleted.count indica cuántos se borraron
};

export const searchExercises = async (
  userId: string,
  { q, bodyPart, portionId, page = 1, limit = 20 }: {
    q?: string; bodyPart?: string; portionId?: string;
    page?: number; limit?: number;
  }
) => {
  const where: any = {
    OR: [{ user_id: null }, { user_id: userId }],
  };

  if (q) where.name = { contains: q, mode: 'insensitive' };
  if (bodyPart) where.Exercise_Muscle_Portion = {
    some: { muscle_portion: { muscle: { name: bodyPart } } },
  };
  if (portionId) where.Exercise_Muscle_Portion = {
    some: { muscle_portion_id: portionId },
  };

  return prisma.exercise.findMany({
    where,
    skip: (page - 1) * limit,
    take: limit,
  });
};

export const assignPortionsToExercise = async (
  exerciseId: string,
  portionIds: string[],
  userId: string
) => {
  // Asegura que el ejercicio existe y pertenece al usuario
  const existingExercise = await prisma.exercise.findFirst({
    where: {
      id: exerciseId,
      OR: [{ user_id: userId }, { user_id: null }], // global o propio
    },
  });
  if (!existingExercise) {
    return { status: 404, message: 'Exercise not found or not yours' };
  }

  // Asegura que todas las porciones existen
  const existingPortions = await prisma.muscle_Portion.findMany({
    where: { id: { in: portionIds } },
  });
  if (existingPortions.length !== portionIds.length) {
    return { status: 400, message: 'Some portionIds do not exist' };
  }

  // Crea las relaciones
  const data = portionIds.map(pid => ({
    exercise_id: exerciseId,
    muscle_portion_id: pid,
    estimated_percentage: 100,
  }));

  await prisma.exercise_Muscle_Portion.createMany({
    data,
    skipDuplicates: true,
  });

  return { status: 200, message: 'Portions assigned' };
};
