import { z } from 'zod'

const setSchema = z.object({
  repetition: z.number().int().positive(),
  weight: z.number().positive(),
  restSeconds: z.number().int().positive(),
  intensityIndicatorId: z.string().uuid().optional(),
  note: z.string().optional(),
})

const workoutExerciseSchema = z.object({
  exerciseId: z.string().uuid(),
  orden: z.number().int().positive().optional(),
  sets: z.array(setSchema).min(1, 'Al menos un set es requerido'),
})

const workoutSchema = z.object({
  name: z.string().min(1),
  date: z.string().datetime(),
  secondsDuration: z.number().int().positive().optional(),
  note: z.string().optional(),
  exercises: z.array(workoutExerciseSchema).min(1, 'Debe incluir al menos un ejercicio'),
})

export const createRoutineSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  goal: z.string().min(1, 'Goal is required'),
  startDate: z.string().datetime(),
  endDate: z.string().datetime(),
  workouts: z.array(workoutSchema).optional(),
})
export type CreateRoutineInput = z.infer<typeof createRoutineSchema>

export const updateRoutineSchema = z
  .object({
    name: z.string().min(1).optional(),
    goal: z.string().optional(),
    startDate: z.string().datetime().optional(),
    endDate: z.string().datetime().optional(),
  })
  .refine(
    data => Object.keys(data).length > 0,
    'Debes enviar al menos un campo para actualizar',
  )
export type UpdateRoutineInput = z.infer<typeof updateRoutineSchema>

export const addSetSchema = z.object({
  workoutId: z.string().uuid(),
  exerciseId: z.string().uuid(),
  set: setSchema,
})
export type AddSetInput = z.infer<typeof addSetSchema>

export const removeSetSchema = z.object({
  setId: z.string().uuid(),
})
export type RemoveSetInput = z.infer<typeof removeSetSchema>
