import { prisma } from '../prisma/client'
import {
  CreateExerciseInput,
  UpdateExerciseInput,
} from '../validators/exercise.validator'

/** Crea un ejercicio personalizado para el usuario */
export const createExercise = async (
  data: CreateExerciseInput,
  userId: string,
  userRole: string,
) => {
  const exerciseData: any = { ...data, isCustom: true }

  if (userRole === 'admin') {
    exerciseData.userId = null
    exerciseData.isCustom = false
  } else {
    exerciseData.userId = userId
  }

  return prisma.exercise.create({ data: exerciseData })
}

/** Lista globales + propios */
export const listExercises = (userId: string) =>
  prisma.exercise.findMany({
    where: { OR: [{ userId: null }, { userId }] },
  })

/** Devuelve un ejercicio global o propio */
export const getExercise = (id: string, userId: string) =>
  prisma.exercise.findFirst({
    where: { id, OR: [{ userId: null }, { userId }] },
  })

/** Actualiza (o clona y actualiza) un ejercicio */
export const updateExercise = async (
  id: string,
  data: UpdateExerciseInput,
  userId: string,
) => {
  const existing = await prisma.exercise.findUnique({ where: { id } });
  if (!existing) {
    return {
      status: 404,
      message: 'Exercise not found',
    };
  }

  // Si el ejercicio es global (sin userId), se clona como personalizado
  if (!existing.userId) {
    const copy = await prisma.exercise.create({
      data: {
        ...existing,
        ...data,
        id: undefined,        // genera nuevo ID
        userId,
        isCustom: true,
      },
    });

    return {
      status: 201,
      message: 'Exercise cloned and updated',
      data: copy,
    };
  }

  // Si el ejercicio pertenece al usuario, se actualiza directamente
  const updated = await prisma.exercise.updateMany({
    where: { id, userId },
    data,
  });

  if (updated.count === 0) {
    return {
      status: 404,
      message: 'Exercise not found or not owned by user',
    };
  }

  const updatedExercise = await prisma.exercise.findUnique({ where: { id } });

  return {
    status: 200,
    message: 'Exercise updated successfully',
    data: updatedExercise,
  };
};


/** Elimina solo la versión del usuario */
export const deleteExercise = (id: string, userId: string) =>
  prisma.exercise.deleteMany({ where: { id, userId } })

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
    equipment,
  }: {
    q?: string
    bodyPart?: string
    portionId?: string
    page?: number
    limit?: number
    orderBy?: string
    order?: 'asc' | 'desc'
    difficulty?: string
    equipment?: string
  },
) => {
  const where: any = { OR: [{ userId: null }, { userId }] }

  if (q) where.name = { contains: q, mode: 'insensitive' }
  if (bodyPart)
    where.exerciseMusclePortions = {
      some: { musclePortion: { muscle: { name: bodyPart } } },
    }
  if (portionId)
    where.exerciseMusclePortions = {
      some: { musclePortionId: portionId },
    }
  if (difficulty) where.difficulty = difficulty
  if (equipment) where.equipment = equipment

  const totalCount = await prisma.exercise.count({ where })

  const data = await prisma.exercise.findMany({
    where,
    skip: (page - 1) * limit,
    take: limit,
    orderBy: { [orderBy]: order },
  })

  return { totalCount, page, limit, data }
}

export const assignPortionsToExercise = async (
  exerciseId: string,
  portions: { id: string; estimatedPercentage: number }[],
  userId: string,
) => {
  const exercise = await prisma.exercise.findFirst({
    where: { id: exerciseId, OR: [{ userId }, { userId: null }] },
  })
  if (!exercise) return { status: 404, message: 'Exercise not found or not yours' }

  const validPortions = await prisma.musclePortion.findMany({
    where: { id: { in: portions.map(p => p.id) } },
  })
  if (validPortions.length !== portions.length)
    return { status: 400, message: 'Some portionIds do not exist' }

  const data = portions.map(p => ({
    exerciseId,
    musclePortionId: p.id,
    estimatedPercentage: p.estimatedPercentage,
  }))

  await prisma.exerciseMusclePortion.createMany({ data, skipDuplicates: true })
  return { status: 200, message: 'Portions assigned' }
}
