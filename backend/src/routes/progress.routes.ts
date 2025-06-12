import { Router } from 'express'
import { requireAuth } from '../middlewares/requireAuth'
import * as Ctrl from '../controllers/progress.controller'
import * as ProgressCtrl from '../controllers/progress.controller';
const router = Router()
router.use(requireAuth)
router.get('/exercise/:id/history/grouped', ProgressCtrl.getGroupedExerciseHistory);
router.get('/exercise/:exerciseId/history', Ctrl.exerciseHistory)
router.get('/exercise/:id/pr', ProgressCtrl.getExercisePR);

export default router
