import { z } from 'zod';

export const passwordSchema = z
    .string()
    .min(8, { message: 'La contraseña debe tener al menos 8 caracteres.' })
    .regex(/[a-z]/, 'Debe tener una minúscula')
    .regex(/[A-Z]/, 'Debe tener una mayúscula')
    .regex(/[0-9]/, 'Debe tener un número')
    .regex(/[^A-Za-z0-9]/, 'Debe tener un caracter especial');
