import { RequestHandler } from 'express';
import * as RoutineService from '../services/routine.service';
import {
  createRoutineSchema,
  updateRoutineSchema,
  addSetSchema,
  removeSetSchema,
} from '../validators/routine.validator';

/* -------- CREATE -------- */
export const createRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const data = createRoutineSchema.parse(req.body);
    const routine = await RoutineService.createRoutine(userId, data);
    res.status(201).json(routine);
    return;
  } catch (err) {
    next(err);
  }
};

/* -------- READ ALL -------- */
export const listRoutines: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const routines = await RoutineService.listRoutines(userId ?? '');
    res.json(routines);
  } catch (err) {
    next(err);
  }
};

/* -------- READ ONE -------- */
export const getRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const routine = await RoutineService.getRoutine(req.params.id, userId ?? '');
    if (!routine) {
      res.status(404).json({ message: 'Not found' });
      return;
    }
    res.json(routine);
  } catch (err) {
    next(err);
  }
};

/* -------- UPDATE -------- */
export const updateRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const data = updateRoutineSchema.parse(req.body);

    const result = await RoutineService.updateRoutine(
      req.params.id,
      data,
      userId ?? '',
    );

    if (result.status === 404) {
      res.status(404).json({ message: 'Not found or not yours' });
      return;
    }
    res.json({ message: 'Updated' });
  } catch (err) {
    next(err);
  }
};

/* -------- DELETE -------- */
export const deleteRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const result = await RoutineService.deleteRoutine(req.params.id, userId ?? '');

    if (result.count === 0) {
      res.status(404).json({ message: 'Not found or not yours' });
      return;
    }
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};

/* -------- ADD SET -------- */
export const addSet: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const { routineId } = req.params;
    const { workoutId, exerciseId, set } = addSetSchema.parse(req.body);

    const result = await RoutineService.addSetToExercise(
      routineId,
      workoutId,
      exerciseId,
      set,
      userId,
    );

    if (result.status !== 201) {
      res.status(result.status).json({ message: result.message });
      return;
    }

    res.status(201).json(result.data);
  } catch (err) {
    next(err);
  }
};

/* -------- REMOVE SET -------- */
export const removeSet: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const { routineId } = req.params;
    const { setId } = removeSetSchema.parse(req.body);

    const result = await RoutineService.removeSetFromExercise(
      routineId,
      setId,
      userId,
    );

    if (result.status !== 200) {
      res.status(result.status).json({ message: result.message });
      return;
    }

    res.json({ message: 'Set removed successfully' });
  } catch (err) {
    next(err);
  }
};
