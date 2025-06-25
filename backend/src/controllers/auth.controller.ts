import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { comparePassword, hashPassword } from '../utils/hash';
import { generateToken } from '../utils/jwt';

const prisma = new PrismaClient();

export const registerUser = async (req: Request, res: Response): Promise<void> => {
    try{
        const { email, password, confirmPassword, rol } = req.body;//Se extraen los datos del cuerpo de la solicitud Post/register
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
        res.status(201).json({ token, user: { id: newUser.id,
            email: newUser.email,
            rol: newUser.rol,
        }, message: 'Usuario registrado exitosamente.' } );



    }catch (error) {
        console.error(error),
        res.status(500).json({ message: 'Error interno del servidor.' });
    }

};
