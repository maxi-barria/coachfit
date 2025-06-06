
import { prisma } from '../prisma/client';
import {
  CreateExerciseInput,
  UpdateExerciseInput,
} from '../validators/exercise.validator';

/** Crea un ejercicio personalizado para el usuario */
export const createExercise = async (
  data: CreateExerciseInput,
  userId: string,
  userRole: string
) => {
  const exerciseData: any = {
    ...data,
    is_custom: true,
  };

  // Si el usuario es admin y no especificó user_id, se crea como global
  if (userRole === 'admin') {
    exerciseData.user_id = null;
    exerciseData.is_custom = false;
  } else {
    // Usuario normal: siempre asociado a su usuario
    exerciseData.user_id = userId;
  }

  return await prisma.exercise.create({
    data: exerciseData,
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
  {
    q,
    bodyPart,
    portionId,
    page = 1,
    limit = 20,
    orderBy = 'name',
    order = 'asc',
    difficulty,
    equipment
  }: {
    q?: string;
    bodyPart?: string;
    portionId?: string;
    page?: number;
    limit?: number;
    orderBy?: string;
    order?: 'asc' | 'desc';
    difficulty?: string;
    equipment?: string;
  }
) => {
  const where: any = {
    OR: [{ user_id: null }, { user_id: userId }],
  };

  if (q) where.name = { contains: q, mode: 'insensitive' };
  if (bodyPart) {
    where.Exercise_Muscle_Portion = {
      some: { muscle_portion: { muscle: { name: bodyPart } } },
    };
  }
  if (portionId) {
    where.Exercise_Muscle_Portion = {
      some: { muscle_portion_id: portionId },
    };
  }
  if (difficulty) where.difficulty = difficulty;
  if (equipment) where.equipment = equipment;

  const totalCount = await prisma.exercise.count({ where });

  const data = await prisma.exercise.findMany({
    where,
    skip: (page - 1) * limit,
    take: limit,
    orderBy: { [orderBy]: order },
  });

  return {
    totalCount,
    page,
    limit,
    data,
  };
};


export const assignPortionsToExercise = async (
  exerciseId: string,
  portions: { id: string; estimated_percentage: number }[],
  userId: string
) => {
  // Verifica que el ejercicio existe y es del usuario (o global)
  const existingExercise = await prisma.exercise.findFirst({
    where: {
      id: exerciseId,
      OR: [{ user_id: userId }, { user_id: null }],
    },
  });
  if (!existingExercise) {
    return { status: 404, message: 'Exercise not found or not yours' };
  }

  // Verifica que todas las porciones existen
  const existingPortions = await prisma.muscle_Portion.findMany({
    where: { id: { in: portions.map(p => p.id) } },
  });
  if (existingPortions.length !== portions.length) {
    return { status: 400, message: 'Some portionIds do not exist' };
  }

  // Inserta las relaciones
  const data = portions.map(p => ({
    exercise_id: exerciseId,
    muscle_portion_id: p.id,
    estimated_percentage: p.estimated_percentage,
  }));

  await prisma.exercise_Muscle_Portion.createMany({
    data,
    skipDuplicates: true,
  });

  return { status: 200, message: 'Portions assigned' };
};
