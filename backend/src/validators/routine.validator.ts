import { z } from 'zod';

/* -------- SET -------- */
const setSchema = z.object({
  repetition: z.number().int().positive(),
  weight: z.number().positive(),
  restSeconds: z.number().int().positive(),
  intensityIndicatorId: z.string().uuid().optional(),
  note: z.string().optional(),
});

/* -------- WORKOUT EXERCISE -------- */
const workoutExerciseSchema = z.object({
  exerciseId: z.string().uuid(),
  orden: z.number().int().positive().optional(),
  sets: z.array(setSchema).min(1, 'Al menos un set es requerido'),
});

/* -------- WORKOUT (crear junto a rutina) -------- */
const workoutSchema = z.object({
  name: z.string().min(1),
  date: z.string().datetime(),
  secondsDuration: z.number().int().positive().optional(),
  note: z.string().optional(),
  exercises: z.array(workoutExerciseSchema).min(1),
});
export type CreateWorkoutInput = z.infer<typeof workoutSchema>;

/* ------------------------------------------------------------------
 * 1. CREATE ROUTINE
 * ------------------------------------------------------------------ */
export const createRoutineSchema = z
  .object({
    name: z.string().min(1, 'Name is required'),
    goal: z.string().optional(),
    startDate: z.string().datetime().optional(),
    endDate: z.string().datetime().optional(),
    workouts: z.array(workoutSchema).optional(),
  })
  .refine(
    (d) => (d.startDate && d.endDate) || (!d.startDate && !d.endDate),
    { message: 'Si envías una fecha debes enviar ambas', path: ['startDate'] },
  );
export type CreateRoutineInput = z.infer<typeof createRoutineSchema>;

/* ------------------------------------------------------------------
 * 2. UPDATE ROUTINE
 * ------------------------------------------------------------------ */
export const updateRoutineSchema = z
  .object({
    name: z.string().min(1).optional(),
    goal: z.string().optional(),
    startDate: z.string().datetime().optional(),
    endDate: z.string().datetime().optional(),
  })
  .refine(
    (d) => Object.keys(d).length > 0,
    { message: 'Debes enviar al menos un campo' },
  )
  .refine(
    (d) => (d.startDate && d.endDate) || (!d.startDate && !d.endDate),
    { message: 'Si actualizas una fecha, debes actualizar ambas', path: ['startDate'] },
  );
export type UpdateRoutineInput = z.infer<typeof updateRoutineSchema>;

/* ------------------------------------------------------------------
 * 3. ADD EXERCISE TO WORKOUT  🆕
 * ------------------------------------------------------------------ */
export const addExerciseSchema = z.object({
  workoutId : z.string().uuid(),
  exerciseId: z.string().uuid(),
  orden     : z.number().int().positive().optional(),
  sets      : z.array(setSchema).min(1, 'Al menos un set'),
});
export type AddExerciseInput = z.infer<typeof addExerciseSchema>;

/* ------------------------------------------------------------------
 * 4. ADD / REMOVE SET
 * ------------------------------------------------------------------ */
export const addSetSchema = z.object({
  workoutId : z.string().uuid(),
  exerciseId: z.string().uuid(),
  set       : setSchema,
});
export type AddSetInput = z.infer<typeof addSetSchema>;

export const removeSetSchema = z.object({
  setId: z.string().uuid(),
});
export type RemoveSetInput = z.infer<typeof removeSetSchema>;
