
import { RequestHandler } from 'express'
import { CoachClientService } from '../services/coachClient.service'
import {
  createCoachClientSchema,
  updateCoachClientSchema,
} from '../validators/coachClient.validator'

const service = new CoachClientService()

/* --------- LIST ALL (coach) ------------------------ */
export const listCoachClients: RequestHandler = async (req, res, next) => {
  try {
    const coachId = req.params.coachId
    if (!coachId) {
      res.status(400).json({ message: 'Falta coachId' })
      return
    }

    const data = await service.getAll(coachId)
    res.json(data)
    return
  } catch (err) {
    next(err)
  }
}

/* --------- GET BY ID ------------------------------- */
export const getCoachClient: RequestHandler = async (req, res, next) => {
  try {
    const { id } = req.params
    const data = await service.getById(id)

    if (!data) {
      res.status(404).json({ message: 'Relación no encontrada' })
      return
    }

    res.json(data)
    return
  } catch (err) {
    next(err)
  }
}

/* --------- CREATE --------------------------------- */
export const createCoachClient: RequestHandler = async (req, res, next) => {
  try {
    const parsed = createCoachClientSchema.parse(req.body)
    const created = await service.create(parsed)
    res.status(201).json(created)
    return
  } catch (err) {
    next(err)
  }
}

/* --------- UPDATE --------------------------------- */
export const updateCoachClient: RequestHandler = async (req, res, next) => {
  try {
    const { id } = req.params
    const data = updateCoachClientSchema.parse(req.body)

    const updated = await service.update(id, data)
    if (!updated) {
      res.status(404).json({ message: 'Relación no encontrada' })
      return
    }

    res.json(updated)
    return
  } catch (err) {
    next(err)
  }
}

/* --------- DELETE --------------------------------- */
export const deleteCoachClient: RequestHandler = async (req, res, next) => {
  try {
    const { id } = req.params
    await service.delete(id)
    res.status(204).send()
    return
  } catch (err: any) {
    res.status(404).json({ message: err.message || 'Relación no encontrada' })
    return
  }
}
