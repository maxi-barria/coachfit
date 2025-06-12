import { Router } from 'express'
import { requireAuth } from '../middlewares/requireAuth'
import * as WCtrl from '../controllers/workoutSession.controller'

const router = Router()
router.use(requireAuth)

/* Sesión de workout (tracking) */
router.post('/', WCtrl.start)            // iniciar sesión
router.get('/',  WCtrl.listSessions)     // listar
router.get('/:id', WCtrl.getSession)     // detalle
router.put('/:sessionId/end', WCtrl.end) // cerrar sesión
router.delete('/:id', WCtrl.deleteSession)

/* Sets dentro de la sesión */
router.post('/:sessionId/sets',  WCtrl.addSet)
router.delete('/:sessionId/sets', WCtrl.removeSet)

export default router
