import { z } from 'zod'

/* ---------- Sub-esquema de Set realizado ---------- */
export const setSessionSchema = z.object({
  workoutExerciseId: z.string().uuid(),
  rep: z.number().int().positive(),
  weight: z.number().positive(),
  restSeconds: z.number().int().positive(),
  intensityIndicatorId: z.string().uuid().optional(),
})

/* ---------- Iniciar sesión de workout ---------- */
export const startSessionSchema = z.object({
  workoutId: z.string().uuid(),
  comment: z.string().optional(),
})

/* ---------- Agregar set a la sesión ---------- */
export const addSetSchema = setSessionSchema

/* ---------- Cerrar / actualizar sesión ---------- */
export const endSessionSchema = z
  .object({
    secondsDuration: z.number().int().positive().optional(), // duración real
    comment: z.string().optional(),
  })
  .refine(d => Object.keys(d).length > 0, 'Envía al menos un campo para cerrar la sesión')
  
export const removeSetSessionSchema = z.object({
  setSessionId: z.string().uuid(),
});

/* ---------- Tipos ---------- */
export type StartSessionInput = z.infer<typeof startSessionSchema>
export type AddSetInput      = z.infer<typeof addSetSchema>
export type EndSessionInput  = z.infer<typeof endSessionSchema>
export type RemoveSetSessionInput = z.infer<typeof removeSetSessionSchema>
