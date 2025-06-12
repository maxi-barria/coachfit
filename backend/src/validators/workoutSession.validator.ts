import { z } from 'zod'

/* ---------- Sub-esquema SetSession ---------- */
export const setSessionSchema = z.object({
  workoutExerciseId: z.string().uuid(),
  rep: z.number().int().positive(),
  weight: z.number().positive(),
  restSeconds: z.number().int().positive(),
  intensityIndicatorId: z.string().uuid().optional(),
})

/* ---------- Crear sesión de workout ---------- */
export const createWorkoutSessionSchema = z.object({
  workoutId: z.string().uuid(),
  date: z.string().datetime().optional(),            // default: now()
  secondsDuration: z.number().int().positive().optional(),
  comment: z.string().optional(),
})

/* ---------- Actualizar sesión ---------- */
export const updateWorkoutSessionSchema = z
  .object({
    secondsDuration: z.number().int().positive().optional(),
    comment: z.string().optional(),
  })
  .refine(d => Object.keys(d).length > 0, 'Envía al menos un campo')

/* ---------- Agregar / quitar sets ---------- */
export const addSetSessionSchema = setSessionSchema                     // body
export const removeSetSessionSchema = z.object({ setSessionId: z.string().uuid() })

/* ---------- Tipos ---------- */
export type CreateWorkoutSessionInput = z.infer<typeof createWorkoutSessionSchema>
export type UpdateWorkoutSessionInput = z.infer<typeof updateWorkoutSessionSchema>
export type AddSetSessionInput = z.infer<typeof addSetSessionSchema>
export type RemoveSetSessionInput = z.infer<typeof removeSetSessionSchema>
