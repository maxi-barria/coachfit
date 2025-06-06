// src/controllers/exercise.controller.ts
import { RequestHandler } from 'express';
import * as ExerciseService from '../services/exercise.service';
import {
  createExerciseSchema,
  updateExerciseSchema,
  searchExerciseSchema,
  assignPortionsSchema 
} from '../validators/exercise.validator';

/* -------- CREATE -------- */
export const createExercise: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const userRole = req.user?.rol || 'cliente';

    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const data = createExerciseSchema.parse(req.body);
    const exercise = await ExerciseService.createExercise(data, userId, userRole);

    res.status(201).json(exercise);
    return;
  } catch (err) {
    next(err);
    return;
  }
};


/* -------- READ ALL -------- */
export const listExercises: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const exercises = await ExerciseService.listExercises(userId ?? '');
    res.json(exercises);            
  } catch (err) {
    next(err);
  }
};

/* -------- READ ONE -------- */
export const getExercise: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const exercise = await ExerciseService.getExercise(
      req.params.id,
      userId ?? '',
    );
    if (!exercise) {
      res.status(404).json({ message: 'Not found' });
      return;
    }
    res.json(exercise);
  } catch (err) {
    next(err);
  }
};

/* -------- UPDATE -------- */
export const updateExercise: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const data = updateExerciseSchema.parse(req.body);
    const result = await ExerciseService.updateExercise(
      req.params.id,
      data,
      userId ?? '',
    );

    if (result.status === 0) {
      res.status(404).json({ message: 'Not found or not yours' });
      return;
    }
    res.json({ message: 'Updated' });
  } catch (err) {
    next(err);
  }
};

/* -------- DELETE -------- */
export const deleteExercise: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const result = await ExerciseService.deleteExercise(
      req.params.id,
      userId ?? '',
    );

    if (result.count === 0) {
      res.status(404).json({ message: 'Not found or not yours' });
      return;
    }
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};
/* -------- SEARCH -------- */
export const searchExercises: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const {
      q, bodyPart, portionId, page, limit,
      orderBy = 'name', order = 'asc', difficulty, equipment
    } = req.query;

    const result = await ExerciseService.searchExercises(userId, {
      q: q as string | undefined,
      bodyPart: bodyPart as string | undefined,
      portionId: portionId as string | undefined,
      page: Number(page) || 1,
      limit: Number(limit) || 20,
      orderBy: orderBy as string,
      order: (order as 'asc' | 'desc') || 'asc',
      difficulty: difficulty as string | undefined,
      equipment: equipment as string | undefined,
    });

    res.json(result);
    return;
  } catch (err) {
    next(err);
    return;
  }
};


/* -------- ASSIGN PORTIONS -------- */
export const assignPortions: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }

    const { exerciseId } = req.params;
    const { portions } = assignPortionsSchema.parse(req.body);

    const result = await ExerciseService.assignPortionsToExercise(
      exerciseId,
      portions,
      userId
    );

    if (result.status === 404) {
      res.status(404).json({ message: result.message });
      return;
    }

    if (result.status === 400) {
      res.status(400).json({ message: result.message });
      return;
    }

    res.json({ message: 'Portions assigned successfully' });
    return;
  } catch (err) {
    next(err);
    return;
  }
};


