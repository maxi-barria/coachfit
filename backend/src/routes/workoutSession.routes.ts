import { Router } from 'express'
import { requireAuth } from '../middlewares/requireAuth'
import * as WCtrl from '../controllers/workoutSession.controller'

const router = Router()
router.use(requireAuth)

router.post('/', WCtrl.createSession)
router.get('/', WCtrl.listSessions)
router.get('/:id', WCtrl.getSession)
router.put('/:id', WCtrl.updateSession)
router.delete('/:id', WCtrl.deleteSession)

router.post('/:sessionId/sets', WCtrl.addSet)
router.delete('/:sessionId/sets', WCtrl.removeSet)

export default router
