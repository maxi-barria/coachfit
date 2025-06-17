
import { RequestHandler } from 'express';
import * as RoutineService from '../services/routine.service';
import {
  createRoutineSchema,
  updateRoutineSchema,
  addSetSchema,
  removeSetSchema,
  addExerciseSchema,
} from '../validators/routine.validator';

/* --------------------------- CREATE ROUTINE --------------------------- */
export const createRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const body = createRoutineSchema.parse(req.body);
    const routine = await RoutineService.createRoutine(userId, body);

    res.status(201).json(routine);
    return;
  } catch (err) {
    next(err);
  }
};

/* --------------------------- LIST ROUTINES --------------------------- */
export const listRoutines: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const routines = await RoutineService.listRoutines(userId ?? '');

    res.json(routines);
    return;
  } catch (err) {
    next(err);
  }
};

/* ---------------------------- GET ROUTINE ---------------------------- */
export const getRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const routine = await RoutineService.getRoutine(req.params.id, userId ?? '');

    if (!routine) {
      res.status(404).json({ message: 'Not found' });
      return;
    }

    res.json(routine);
    return;
  } catch (err) {
    next(err);
  }
};

/* --------------------------- UPDATE ROUTINE -------------------------- */
export const updateRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const body   = updateRoutineSchema.parse(req.body);

    const result = await RoutineService.updateRoutine(
      req.params.id,
      body,
      userId ?? '',
    );

    if (result.status === 404) {
      res.status(404).json({ message: 'Not found or not yours' });
      return;
    }

    res.json({ message: 'Updated' });
    return;
  } catch (err) {
    next(err);
  }
};

/* --------------------------- DELETE ROUTINE -------------------------- */
export const deleteRoutine: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const result = await RoutineService.deleteRoutine(req.params.id, userId ?? '');

    if (result.count === 0) {
      res.status(404).json({ message: 'Not found or not yours' });
      return;
    }

    res.status(204).send();
    return;
  } catch (err) {
    next(err);
  }
};

/* --------------------------- CREATE WORKOUT -------------------------- */
export const createWorkout: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const result = await RoutineService.createWorkout(
      req.params.id,   // :id = routineId
      req.body,
      userId ?? '',
    );

    if (result.status === 404) {
      res.status(404).json({ message: 'Not found or not yours' });
      return;
    }

    res.status(201).json(result.data);
    return;
  } catch (err) {
    next(err);
  }
};

/* --------------------------- ADD EXERCISE ---------------------------- */
export const addExercise: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const body = addExerciseSchema.parse({
      ...req.body,
      workoutId: req.params.workoutId,
    });

    const result = await RoutineService.addExerciseToWorkout(
      req.params.workoutId,
      body,
      userId,
    );

    if (result.status !== 201) {
      res.status(result.status).json({ message: result.message });
      return;
    }

    res.status(201).json(result.data);
    return;
  } catch (err) {
    next(err);
  }
};

/* ----------------------------- ADD SET ------------------------------- */
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
    return;
  } catch (err) {
    next(err);
  }
};

/* ---------------------------- REMOVE SET ----------------------------- */
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

    res.status(204).send();
    return;
  } catch (err) {
    next(err);
  }
};
