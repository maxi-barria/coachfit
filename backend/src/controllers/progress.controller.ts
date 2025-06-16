import { RequestHandler } from 'express'
import * as P from '../services/progress.service'
import * as WSSvc from '../services/workoutSession.service';

export const exerciseHistory: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id
    const { exerciseId } = req.params

    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' })
      return
    }

    const data = await P.getExerciseHistory(exerciseId, userId)
    res.json(data)
  } catch (err) {
    next(err)
  }
}
export const getGroupedExerciseHistory: RequestHandler = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const exerciseId = req.params.id;

    if (!userId) {
      res.status(401).json({ message: 'Unauthorized' });
      return 
    }

    const history = await WSSvc.getExerciseHistory(userId, exerciseId);
    res.json(history);
  } catch (error) {
    next(error);
  }
};
export const getExercisePR: RequestHandler = async (req, res, next) => {
  const userId = req.user?.id;
  const exerciseId = req.params.id;

  if (!userId){
    res.status(401).json({ message: 'Unauthorized' });
    return }

  try {
    const pr = await WSSvc.getExercisePR(userId, exerciseId);
    if (!pr) {

   
      res.status(404).json({ message: 'PR not found' });
      return  }
    res.json(pr);
  } catch (err) {
    next(err);
  }
};
