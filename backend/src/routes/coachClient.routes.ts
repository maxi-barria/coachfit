import { Router } from 'express';
import * as CoachClientController from '../controllers/coachClient.controller';


const router = Router();

router.get('/:coachId', CoachClientController.listCoachClients);
router.get('/detail/:id', CoachClientController.getCoachClient);
router.post('/', CoachClientController.createCoachClient);
router.put('/:id', CoachClientController.updateCoachClient);
router.delete('/:id', CoachClientController.deleteCoachClient);


export default router;
