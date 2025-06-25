import {z} from 'zod';

export const registerUserSchema = z.object({
    email: z.string().email({ message: 'El correo electrónico no es válido.' }),
    password: z.
    string()
    .min(8, { message: 'La contraseña debe tener al menos 8 caracteres.' })
    .regex(/[a-z]/, 'Debe tener una minúscula')
    .regex(/[A-Z]/, 'Debe tener una mayúscula')
    .regex(/[0-9]/, 'Debe tener un número')
    .regex(/[^A-Za-z0-9]/, 'Debe tener un caracter especial'),

    confirmPassword: z.string(),
    rol: z.enum(['client', 'admin', 'coach']).optional(), // Rol opcional, por defecto será 'client'
}).refine((data) => data.password === data.confirmPassword, {
    message: 'Las contraseñas no coinciden.',
    path: ['confirmPassword'], // Path to the error
});