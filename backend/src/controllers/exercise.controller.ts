// src/controllers/exercise.controller.ts
import { RequestHandler } from 'express';
import * as ExerciseService from '../services/exercise.service';
import {
  createExerciseSchema,
  updateExerciseSchema,
} from '../validators/exercise.validator';

/* -------- CREATE -------- */
export const createExercise: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return;             
    }

    const data = createExerciseSchema.parse(req.body);
    const exercise = await ExerciseService.createExercise(data, userId);

    res.status(201).json(exercise);  
  } catch (err) {
    next(err);
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
