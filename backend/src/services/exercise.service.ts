
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
