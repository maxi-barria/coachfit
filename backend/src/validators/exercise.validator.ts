import { z } from 'zod'

export const createExerciseSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  type: z.string().optional(),
  imageUrl: z.string().optional(),
  gifUrl: z.string().optional(),
  secondsDuration: z.number().int().positive().optional(),
  difficulty: z.enum(['beginner', 'intermediate', 'advanced']).optional(),
  equipment: z.string().optional(),
})

export const searchExerciseSchema = z.object({
  q: z.string().trim().optional(),
  bodyPart: z.string().trim().optional(),
  portionId: z.string().uuid().optional(),
  page: z.string().regex(/^\d+$/).transform(Number).optional(),
  limit: z.string().regex(/^\d+$/).transform(Number).optional(),
  orderBy: z
    .enum(['name', 'type', 'difficulty', 'createdAt', 'updatedAt'])
    .optional(),
  order: z.enum(['asc', 'desc']).optional(),
  difficulty: z.enum(['beginner', 'intermediate', 'advanced']).optional(),
  equipment: z.string().optional(),
})

export const assignPortionsSchema = z.object({
  portions: z
    .array(
      z.object({
        id: z.string().uuid(),
        estimatedPercentage: z.number().int().min(1).max(100),
      }),
    )
    .min(1, 'Al menos una porción es requerida'),
})

export const updateExerciseSchema = createExerciseSchema.partial()

export type CreateExerciseInput = z.infer<typeof createExerciseSchema>
export type UpdateExerciseInput = z.infer<typeof updateExerciseSchema>
export type AssignPortionsInput = z.infer<typeof assignPortionsSchema>
export type SearchExerciseQuery = z.infer<typeof searchExerciseSchema>
