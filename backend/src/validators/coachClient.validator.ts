import { z } from 'zod';

export const createCoachClientSchema = z.object({
    coachId: z.string().uuid(),
    clientId: z.string().uuid(),
    note: z.string().optional(),
    startDate: z.coerce.date(),
    endDate: z.coerce.date().optional(),
});

export const updateCoachClientSchema = z.object({
    note: z.string().optional(),
    startDate: z.coerce.date().optional(),
    endDate: z.coerce.date().optional(),
});
