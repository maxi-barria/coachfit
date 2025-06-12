import { RequestHandler } from 'express'
import * as WSvc from '../services/workoutSession.service'
import {
  startSessionSchema,
  addSetSchema,
  endSessionSchema,
  removeSetSessionSchema,
} from '../validators/workoutSession.validator'

/* ---------- START SESSION ---------- */
export const start: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }

    const data = startSessionSchema.parse(req.body)
    const session = await WSvc.startSession(userId, data)
    res.status(201).json(session); return
  } catch (err) { next(err) }
}

/* ---------- LIST SESSIONS ---------- */
export const listSessions: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    const page  = Number(req.query.page  ?? 1)
    const limit = Number(req.query.limit ?? 20)

    const sessions = await WSvc.listSessions(userId ?? '', page, limit)
    res.json(sessions)
  } catch (err) { next(err) }
}

/* ---------- GET ONE SESSION ---------- */
export const getSession: RequestHandler = async (req, res, next) => {
  try {
    const userId  = req.user?.id
    const session = await WSvc.getSession(req.params.id, userId ?? '')
    if (!session) { res.status(404).json({ message: 'Not found' }); return }
    res.json(session)
  } catch (err) { next(err) }
}

/* ---------- END SESSION ---------- */
export const end: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }

    const data = endSessionSchema.parse(req.body)
    const r = await WSvc.endSession(req.params.sessionId, userId, data)
    if (r.status !== 200) { res.status(r.status).json({ message: 'Not found or not yours' }); return }

    res.json({ message: 'Session closed & summary stored' })
  } catch (err) { next(err) }
}

/* ---------- DELETE SESSION ---------- */
export const deleteSession: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    const r = await WSvc.deleteSession(req.params.id, userId ?? '')
    if (r.count === 0) { res.status(404).json({ message: 'Not found or not yours' }); return }
    res.status(204).send()
  } catch (err) { next(err) }
}

/* ---------- ADD SET ---------- */
export const addSet: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }

    const set = addSetSchema.parse(req.body)
    const r = await WSvc.addSet(req.params.sessionId, userId, set)
    if (r.status !== 201) { res.status(r.status).json({ message: 'Not found' }); return }
    res.status(201).json(r.data)
  } catch (err) { next(err) }
}

/* ---------- REMOVE SET ---------- */
export const removeSet: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }

    const { setSessionId } = removeSetSessionSchema.parse(req.body)
    const r = await WSvc.removeSetFromSession(setSessionId, userId)
    if (r.status !== 200) { res.status(r.status).json({ message: r.message }); return }

    res.json({ message: 'Set removed' })
  } catch (err) { next(err) }
}

/* ---------- SUMMARY (by date range) ---------- */
export const summary: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }

    const from = new Date(req.query.from as string)
    const to   = new Date(req.query.to   as string)

    const data = await WSvc.getSummary(userId, from, to)
    res.json(data)
  } catch (err) { next(err) }
}
export const getExerciseHistory: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const exerciseId = req.params.exerciseId;
    if (!userId || !exerciseId) {
      res.status(400).json({ message: 'Faltan parámetros' });
      return;
    }

    const history = await WSvc.getExerciseHistory(userId, exerciseId);
    res.json(history);
  } catch (err) {
    next(err);
  }
};
