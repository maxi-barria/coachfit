import { z } from 'zod';
import { passwordSchema } from './rules/commonSchemas';
export const registerUserSchema = z.object({
    email: z.string().email({ message: 'El correo electrónico no es válido.' }),
    password: passwordSchema,
    confirmPassword: z.string(),
    rol: z.enum(['client', 'admin', 'coach']).optional(), // Rol opcional, por defecto será 'client'
}).refine((data) => data.password === data.confirmPassword, {
    message: 'Las contraseñas no coinciden.',
    path: ['confirmPassword'], // Path to the error
});

export const loginUserSchema = z.object({
    email: z.string().email({ message: 'Correo o contraseña incorrecto.' }),
    password: passwordSchema
});
export const requestResetSchema = z.object({
    email: z.string().email({ message: 'El correo electrónico no es válido.' }),
});

export const verifyCodeSchema = z.object({
    email: z.string().email({ message: 'Correo inválido.' }),
    code: z.string().regex(/^\d{6}$/, { message: 'El código debe tener 6 dígitos numéricos.' })
});


export const resetPasswordSchema = z.object({
    email: z.string().email(),
    code: z.string().regex(/^\d{6}$/, { message: 'El código debe tener 6 dígitos numéricos.' }),
    password: passwordSchema,
    confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
    message: 'Las contraseñas no coinciden.',
    path: ['confirmPassword'],
});

export const changePasswordSchema = z.object({
    currentPassword: passwordSchema,
    newPassword: passwordSchema,
    confirmNewPassword: z.string(),
}).refine((data) => data.newPassword === data.confirmNewPassword, {
    message: 'Las nuevas contraseñas no coinciden.',
    path: ['confirmNewPassword'],
});