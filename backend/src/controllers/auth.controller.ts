import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { comparePassword, hashPassword } from '../utils/hash';
import { generateToken } from '../utils/jwt';
import { sendResetEmail } from '../utils/email';

const prisma = new PrismaClient();

export const registerUser = async (req: Request, res: Response): Promise<void> => {
    try {
        const { email, password, rol } = req.body;//Se extraen los datos del cuerpo de la solicitud Post/register
        const existingUser = await prisma.user.findUnique({ where: { email } });
        if (existingUser) {
            res.status(409).json({ message: 'El Correo ya está en uso.' });
            return;
        }
        const hashedPassword = await hashPassword(password);
        const newUser = await prisma.user.create({
            data: {
                email,
                password: hashedPassword,
                rol: rol || 'client', // Default role is 'client' if not provided
            },
        });
        const token = generateToken(newUser.id, newUser.rol);
        res.status(201).json({
            token, user: {
                id: newUser.id,
                email: newUser.email,
                rol: newUser.rol,
            }, message: 'Usuario registrado exitosamente.'
        });



    } catch (error) {
        console.error(error),
            res.status(500).json({ message: 'Error interno del servidor.' });
    }

};
export const loginUser = async (req: Request, res: Response): Promise<void> => {
    try {
        const { email, password } = req.body;
        const user = await prisma.user.findUnique({ where: { email } });
        if (!user) {
            res.status(404).json({ message: 'Usuario no encontrado.' });
            return;
        }
        const isPasswordValid = await comparePassword(password, user.password);
        if (!isPasswordValid) {
            res.status(401).json({ message: 'Correo o contraseña incorrecto.' });
            return;
        }
        const token = generateToken(user.id, user.rol);
        res.status(200).json({ token, user: { id: user.id, email: user.email, rol: user.rol }, message: 'Inicio de sesión exitoso.' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error interno del servidor.' });

    }
};

export const requestResetPassword = async (req: Request, res: Response): Promise<void> => {
    try {
        const { email } = req.body;

        if (!email) {
            res.status(400).json({ message: 'El correo es obligatorio.' });
            return;
        }

        const user = await prisma.user.findUnique({ where: { email } });

        if (!user) {
            // Por seguridad, responder igual aunque el correo no exista
            res.json({ message: 'Si el correo existe, se ha enviado un enlace.' });
            return;
        }

        const code = Math.floor(100000 + Math.random() * 900000).toString(); // 6 dígitos
        const expiry = new Date(Date.now() + 15 * 60 * 1000); // 15 minutos

        await prisma.user.update({
            where: { email },
            data: {
                resetToken: code,
                resetTokenExpiry: expiry,
            },
        });

        try {
            await sendResetEmail(email, code);
            res.json({ message: 'Correo de recuperación enviado.' });
        } catch (err) {
            console.error('Error enviando correo:', err);
            res.status(500).json({ message: 'Error al enviar el correo.' });
        }
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error interno del servidor.' });
    }
};
export const verifyResetCode = async (req: Request, res: Response): Promise<void> => {
    const { email, code } = req.body;

    // Validación básica (aunque Zod ya debería atraparlo)
    if (!email || !code) {
        res.status(400).json({ message: 'El correo y el código son obligatorios.' });
        return;
    }

    try {
        const user = await prisma.user.findUnique({
            where: { email },
            select: {
                resetToken: true,
                resetTokenExpiry: true,
            },
        });

        if (!user) {
            res.status(404).json({ message: 'Usuario no encontrado.' });
            return;
        }

        if (user.resetToken !== code) {
            res.status(400).json({ message: 'Código inválido.' });
            return;
        }

        if (!user.resetTokenExpiry || user.resetTokenExpiry < new Date()) {
            res.status(410).json({ message: 'El código ha expirado.' }); // mejor semántica
            return;
        }

        res.status(200).json({ message: 'Código válido. Puedes proceder a restablecer tu contraseña.' });
    } catch (error) {
        console.error('Error verificando código:', error);
        res.status(500).json({ message: 'Error interno del servidor.' });
    }
};

export const resetPassword = async (req: Request, res: Response): Promise<void> => {
    const { email, code, password, confirmPassword } = req.body;

    if (!email || !code || !password || !confirmPassword) {
        res.status(400).json({ message: 'Todos los campos son obligatorios.' });
        return;
    }

    if (password !== confirmPassword) {
        res.status(400).json({ message: 'Las contraseñas no coinciden.' });
        return;
    }

    try {
        const user = await prisma.user.findUnique({ where: { email } });

        if (!user) {
            res.status(404).json({ message: 'Usuario no encontrado.' });
            return;
        }
        if (user.resetToken !== code) {
            res.status(400).json({ message: 'Código inválido.' });
            return;
        }

        if (!user.resetTokenExpiry || user.resetTokenExpiry < new Date()) {
            res.status(410).json({ message: 'El código ha expirado.' });
            return;
        }

        const hashedPassword = await hashPassword(password);

        await prisma.user.update({
            where: { email },
            data: {
                password: hashedPassword,
                resetToken: null,
                resetTokenExpiry: null,
            },
        });
        res.status(200).json({ message: 'Contraseña actualizada correctamente.' });
        return;
    } catch (error) {
        console.error('Error al restablecer la contraseña:', error);
        res.status(500).json({ message: 'Error interno del servidor.' });
        return;
    }
};


export const changePassword = async (req: Request, res: Response): Promise<void> => {
    const { currentPassword, newPassword, confirmNewPassword } = req.body;
    const userId = req.user?.id;
    if (!userId) {
        res.status(401).json({ message: 'No autorizado.' });
        return;
    }
    try {
        if (!currentPassword || !newPassword || !confirmNewPassword) {
            res.status(400).json({ message: 'Todos los campos son obligatorios.' });
            return;
        }
        const user = await prisma.user.findUnique({ where: { id: userId } });
        if (!user) {
            res.status(404).json({ message: 'Usuario no encontrado.' });
            return;
        }

        const isCurrentPasswordValid = await comparePassword(currentPassword, user.password);
        if (!isCurrentPasswordValid) {
            res.status(401).json({ message: 'La contraseña actual es incorrecta.' });
            return;
        }
        const hashedNewPassword = await hashPassword(newPassword);
        await prisma.user.update({
            where: { id: userId },
            data: {
                password: hashedNewPassword,
            },
        });
        res.status(200).json({ message: 'Contraseña actualizada correctamente.' });
    } catch (error) {
        console.error('Error al cambiar la contraseña:', error);
        res.status(500).json({ message: 'Error interno del servidor.' });
    }
};









