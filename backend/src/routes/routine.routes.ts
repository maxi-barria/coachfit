// src/routes/routine.routes.ts
import { Router } from 'express';
import { requireAuth } from '../middlewares/requireAuth';
import * as RoutineCtrl from '../controllers/routine.controller';

const router = Router();

// Todas las rutas requieren autenticación
router.use(requireAuth);

/* -------- CRUD principal -------- */
router.get('/', RoutineCtrl.listRoutines);         // Listar rutinas del usuario
router.get('/:id', RoutineCtrl.getRoutine);        // Detalle de una rutina
router.post('/', RoutineCtrl.createRoutine);       // Crear rutina completa
router.put('/:id', RoutineCtrl.updateRoutine);     // Actualizar metadatos
router.delete('/:id', RoutineCtrl.deleteRoutine);  // Eliminar rutina

/* -------- Sets dinámicos -------- */
router.post('/:routineId/add-set', RoutineCtrl.addSet);       // Agregar un set
router.delete('/:routineId/remove-set', RoutineCtrl.removeSet); // Quitar un set

export default router;
