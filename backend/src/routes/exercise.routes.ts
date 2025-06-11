import { Router } from 'express';
import { requireAuth } from '../middlewares/requireAuth'; 
import * as ExerciseCtrl from '../controllers/exercise.controller';

const router = Router();
router.use(requireAuth);  
router.get('/', ExerciseCtrl.listExercises);
router.get('/search', ExerciseCtrl.searchExercises);
router.post('/:exerciseId/portions', ExerciseCtrl.assignPortions);
router.get('/:id', ExerciseCtrl.getExercise);
router.post('/', ExerciseCtrl.createExercise);
router.put('/:id', ExerciseCtrl.updateExercise);
router.delete('/:id', ExerciseCtrl.deleteExercise);

export default router;
