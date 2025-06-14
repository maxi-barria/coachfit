import { Router } from 'express';
import { CoachClientController } from '../controllers/coachClient.controller';

const router = Router();
const controller = new CoachClientController();

router.get('/:coachId', controller.getAll);
router.get('/detail/:id', controller.getById);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.delete('/:id', controller.delete);

export default router;
