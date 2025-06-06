import { z } from 'zod';

export const createExerciseSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  type: z.string().optional(),
  seconds_duration: z.number().int().positive().optional(),
});
/* ----------------- BUSCAR / FILTRAR ----------------- */
export const searchExerciseSchema = z.object({
  q: z.string().trim().optional(),
  bodyPart: z.string().trim().optional(),
  portionId: z.string().uuid().optional(),
  page: z
    .string()
    .regex(/^\d+$/)
    .transform(Number)
    .optional(),
  limit: z
    .string()
    .regex(/^\d+$/)
    .transform(Number)
    .optional(),
});
/* ----------- Asignar porciones a ejercicio ----------- */
export const assignPortionsSchema = z.object({
  portionIds: z.array(z.string().uuid()).min(1, 'Al menos una porción es requerida')
});

export type AssignPortionsInput = z.infer<typeof assignPortionsSchema>;
export const updateExerciseSchema = createExerciseSchema.partial();
export type CreateExerciseInput = z.infer<typeof createExerciseSchema>;
export type UpdateExerciseInput = z.infer<typeof updateExerciseSchema>;
export type SearchExerciseQuery = z.infer<typeof searchExerciseSchema>;
