import { prisma } from '../prisma/client'
import {
  CreateWorkoutSessionInput,
  UpdateWorkoutSessionInput,
  AddSetSessionInput,
} from '../validators/workoutSession.validator'

/* ---------- Crear sesión ---------- */
export const createWorkoutSession = (userId: string, data: CreateWorkoutSessionInput) =>
  prisma.workoutSession.create({
    data: {
      userId,
      workoutId: data.workoutId,
      date: data.date ? new Date(data.date) : undefined,
      secondsDuration: data.secondsDuration ?? undefined,
      comment: data.comment ?? undefined,
    },
    include: { workout: true },
  })

/* ---------- Listar sesiones del usuario ---------- */
export const listWorkoutSessions = (userId: string, page = 1, limit = 20) =>
  prisma.workoutSession.findMany({
    where: { userId },
    orderBy: { date: 'desc' },
    skip: (page - 1) * limit,
    take: limit,
    include: { workout: true },
  })

/* ---------- Obtener una sesión ---------- */
export const getWorkoutSession = (id: string, userId: string) =>
  prisma.workoutSession.findFirst({
    where: { id, userId },
    include: {
      workout: true,
      setSessions: { include: { workoutExercise: { include: { exercise: true } } } },
    },
  })

/* ---------- Actualizar sesión ---------- */
export const updateWorkoutSession = async (
  id: string,
  data: UpdateWorkoutSessionInput,
  userId: string,
) => {
  const updated = await prisma.workoutSession.updateMany({
    where: { id, userId },
    data: {
      secondsDuration: data.secondsDuration ?? undefined,
      comment: data.comment ?? undefined,
    },
  })
  return updated.count === 0 ? { status: 404 } : { status: 200 }
}

/* ---------- Borrar sesión ---------- */
export const deleteWorkoutSession = (id: string, userId: string) =>
  prisma.workoutSession.deleteMany({ where: { id, userId } })

/* ---------- Agregar set a sesión ---------- */
export const addSetToSession = async (
  sessionId: string,
  set: AddSetSessionInput,
  userId: string,
) => {
  /* Verifica que la sesión pertenece al usuario */
  const session = await prisma.workoutSession.findFirst({
    where: { id: sessionId, userId },
  })
  if (!session) return { status: 404, message: 'Session not found' }

  const newSet = await prisma.setSession.create({
    data: {
      workoutSessionId: sessionId,
      workoutExerciseId: set.workoutExerciseId,
      rep: set.rep,
      weight: set.weight,
      restSeconds: set.restSeconds,
      intensityIndicatorId: set.intensityIndicatorId ?? undefined,
    },
  })
  return { status: 201, data: newSet }
}

/* ---------- Quitar set de sesión ---------- */
export const removeSetFromSession = async (
  setSessionId: string,
  userId: string,
) => {
  /* Verifica propiedad del usuario */
  const set = await prisma.setSession.findUnique({
    where: { id: setSessionId },
    include: { workoutSession: true },
  })
  if (!set || set.workoutSession.userId !== userId)
    return { status: 404, message: 'Set not found or not yours' }

  await prisma.setSession.delete({ where: { id: setSessionId } })
  return { status: 200 }
}
