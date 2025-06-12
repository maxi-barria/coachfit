import { prisma } from '../prisma/client'
import {
  StartSessionInput,
  AddSetInput,
  EndSessionInput,
} from '../validators/workoutSession.validator'

/* ---------- Iniciar sesión ---------- */
export const startSession = (userId: string, data: StartSessionInput) =>
  prisma.workoutSession.create({
    data: {
      userId,
      workoutId: data.workoutId,
      comment: data.comment ?? undefined,
    },
  })

/* ---------- Agregar set a la sesión ---------- */
export const addSet = async (
  sessionId: string,
  userId: string,
  set: AddSetInput,
) => {
  const session = await prisma.workoutSession.findFirst({
    where: { id: sessionId, userId },
  })
  if (!session) return { status: 404 }

  const created = await prisma.setSession.create({
    data: {
      workoutSessionId: sessionId,
      workoutExerciseId: set.workoutExerciseId,
      rep: set.rep,
      weight: set.weight,
      restSeconds: set.restSeconds,
      intensityIndicatorId: set.intensityIndicatorId ?? undefined,
    },
  })
  return { status: 201, data: created }
}

/* ---------- Cerrar sesión y generar summary ---------- */
export const endSession = async (
  sessionId: string,
  userId: string,
  data: EndSessionInput,
) => {
  const session = await prisma.workoutSession.findFirst({
    where: { id: sessionId, userId },
    include: { setSessions: true },
  })
  if (!session) return { status: 404 }

  const totalSets   = session.setSessions.length
  const totalReps   = session.setSessions.reduce((s, x) => s + x.rep, 0)
  const totalVolume = session.setSessions.reduce((s, x) => s + x.rep * x.weight, 0)

  await prisma.$transaction([
    prisma.workoutSession.update({
      where: { id: sessionId },
      data: {
        endedAt: new Date(),
        secondsDuration: data.secondsDuration ?? session.secondsDuration,
        comment: data.comment ?? session.comment,
      },
    }),
    prisma.workoutSessionSummary.upsert({
      where: { workoutSessionId: sessionId },
      update: { totalVolume, totalSets, totalReps },
      create: {
        workoutSessionId: sessionId,
        totalVolume,
        totalSets,
        totalReps,
      },
    }),
  ])

  return { status: 200 }
}

/* ---------- Listar sesiones ---------- */
export const listSessions = (
  userId: string,
  page = 1,
  limit = 20,
) =>
  prisma.workoutSession.findMany({
    where: { userId },
    orderBy: { startedAt: 'desc' },
    skip: (page - 1) * limit,
    take: limit,
    include: { workout: true },
  })

/* ---------- Obtener sesión (detalle) ---------- */
export const getSession = (id: string, userId: string) =>
  prisma.workoutSession.findFirst({
    where: { id, userId },
    include: {
      workout: true,
      setSessions: {
        include: {
          workoutExercise: { include: { exercise: true } },
        },
      },
      summary: true,
    },
  })

/* ---------- Eliminar sesión ---------- */
export const deleteSession = (id: string, userId: string) =>
  prisma.workoutSession.deleteMany({ where: { id, userId } })

/* ---------- Obtener resumen por rango de fechas ---------- */
export const getSummary = (
  userId: string,
  from: Date,
  to: Date,
) =>
  prisma.workoutSessionSummary.findMany({
    where: {
      workoutSession: {
        userId,
        startedAt: { gte: from, lte: to },
      },
    },
    include: {
      workoutSession: { select: { startedAt: true, workout: true } },
    },
    orderBy: { createdAt: 'asc' },
  })

  export const removeSetFromSession = async (
  setSessionId: string,
  userId: string,
) => {
  const set = await prisma.setSession.findUnique({
    where: { id: setSessionId },
    include: { workoutSession: true },
  });
  if (!set || set.workoutSession.userId !== userId)
    return { status: 404, message: 'Set not found or not yours' };

  await prisma.setSession.delete({ where: { id: setSessionId } });
  return { status: 200 };
};
export const getExerciseHistory = async (userId: string, exerciseId: string) => {
  const sets = await prisma.setSession.findMany({
    where: {
      workoutExercise: {
        exerciseId,
        workout: { userId },
      },
    },
    orderBy: { createdAt: 'asc' },
    include: {
      workoutSession: {
        include: { workout: true },
      },
      intensityIndicator: true,
    },
  });

  const grouped: Record<string, any[]> = {};

  for (const set of sets) {
    const sessionId = set.workoutSessionId;
    if (!grouped[sessionId]) {
      grouped[sessionId] = [];
    }
    grouped[sessionId].push({
      date: set.workoutSession.startedAt,
      workoutName: set.workoutSession.workout.name,
      rep: set.rep,
      weight: set.weight,
      intensity: set.intensityIndicator
        ? `${set.intensityIndicator.name} ${set.intensityIndicator.value}`
        : null,
    });
  }

  return Object.values(grouped); // <- esto ahora será List<List<SetData>> esperado por Flutter
};
export const getExercisePR = async (userId: string, exerciseId: string) => {
  const pr = await prisma.setSession.findFirst({
    where: {
      workoutExercise: {
        exerciseId,
        workout: {
          userId,
        },
      },
    },
    orderBy: {
      weight: 'desc',
    },
    include: {
      workoutSession: true,
    },
  });

  if (!pr) return null;

  const estimated1RM = Math.round(pr.weight * (1 + pr.rep / 30));

  return {
    weight: pr.weight,
    reps: pr.rep,
    estimated1RM,
    date: pr.workoutSession.startedAt,
  };
};

