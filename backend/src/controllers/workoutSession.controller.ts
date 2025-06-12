import { RequestHandler } from 'express'
import * as WSvc from '../services/workoutSession.service'
import {
  createWorkoutSessionSchema,
  updateWorkoutSessionSchema,
  addSetSessionSchema,
  removeSetSessionSchema,
} from '../validators/workoutSession.validator'

/* CREATE */
export const createSession: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }
    const data = createWorkoutSessionSchema.parse(req.body)
    const session = await WSvc.createWorkoutSession(userId, data)
    res.status(201).json(session); return
  } catch (err) { next(err) }
}

/* LIST */
export const listSessions: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    const page = Number(req.query.page ?? 1)
    const limit = Number(req.query.limit ?? 20)
    const sessions = await WSvc.listWorkoutSessions(userId ?? '', page, limit)
    res.json(sessions)
  } catch (err) { next(err) }
}

/* GET ONE */
export const getSession: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    const session = await WSvc.getWorkoutSession(req.params.id, userId ?? '')
    if (!session) { res.status(404).json({ message: 'Not found' }); return }
    res.json(session)
  } catch (err) { next(err) }
}

/* UPDATE */
export const updateSession: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    const data = updateWorkoutSessionSchema.parse(req.body)
    const r = await WSvc.updateWorkoutSession(req.params.id, data, userId ?? '')
    if (r.status === 404) { res.status(404).json({ message: 'Not found or not yours' }); return }
    res.json({ message: 'Updated' })
  } catch (err) { next(err) }
}

/* DELETE */
export const deleteSession: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    const r = await WSvc.deleteWorkoutSession(req.params.id, userId ?? '')
    if (r.count === 0) { res.status(404).json({ message: 'Not found or not yours' }); return }
    res.status(204).send()
  } catch (err) { next(err) }
}

/* ADD SET */
export const addSet: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }
    const { sessionId } = req.params
    const set = addSetSessionSchema.parse(req.body)
    const r = await WSvc.addSetToSession(sessionId, set, userId)
    if (r.status !== 201) { res.status(r.status).json({ message: r.message }); return }
    res.status(201).json(r.data)
  } catch (err) { next(err) }
}

/* REMOVE SET */
export const removeSet: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    if (!userId) { res.status(401).json({ message: 'Unauthorized' }); return }
    const { sessionId } = req.params
    const { setSessionId } = removeSetSessionSchema.parse(req.body)
    const r = await WSvc.removeSetFromSession(setSessionId, userId)
    if (r.status !== 200) { res.status(r.status).json({ message: r.message }); return }
    res.json({ message: 'Set removed' })
  } catch (err) { next(err) }
}
