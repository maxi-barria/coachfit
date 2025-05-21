import express, { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { comparePassword, hashPassword } from '../utils/hash';
import { generateToken } from '../utils/jwt';

const router = express.Router();
const prisma = new PrismaClient();

router.post(
  '/login',
  async (req: Request, res: Response): Promise<void> => {
    const { email, password } = req.body;

    if (!email || !password) {
      res.status(400).json({ message: 'Email y contraseña son obligatorios.' });
      return;
    }

    try {
      const user = await prisma.user.findUnique({ where: { email } });
      if (!user) {
        res.status(401).json({ message: 'Credenciales inválidas.' });
        return;
      }

      const ok = await comparePassword(password, user.password);
      if (!ok) {
        res.status(401).json({ message: 'Credenciales inválidas.' });
        return;
      }

      const token = generateToken(user.id);

      res.json({
        token,
        user: { id: user.id, email: user.email, rol: user.rol }
      });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Error interno del servidor.' });
    }
  }
);

router.post('/register', async (req: Request, res: Response): Promise<void> => {
  const { email, password, confirmPassword, rol } = req.body;

  // Validaciones básicas
  if (!email || !password || !confirmPassword) {
    res.status(400).json({ message: 'Todos los campos son obligatorios.' });
    return;
  }

  if (!email.endsWith('@gmail.com')) {
    res.status(400).json({ message: 'Solo se permiten correos Gmail.' });
    return;
  }

  if (password.length < 6) {
    res.status(400).json({ message: 'La contraseña debe tener al menos 6 caracteres.' });
    return;
  }

  if (password !== confirmPassword) {
    res.status(400).json({ message: 'Las contraseñas no coinciden.' });
    return;
  }

  try {
    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) {
      res.status(409).json({ message: 'El correo ya está registrado.' });
      return;
    }

    const hashedPassword = await hashPassword(password);

    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        rol: rol || '', // puede ser 'cliente' u otro valor por defecto
      },
    });

    const token = generateToken(user.id);

    res.status(201).json({
      success: true,
      message: 'Usuario registrado exitosamente.',
      token,
      user: {
        id: user.id,
        email: user.email,
        rol: user.rol,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error interno del servidor.' });
  }
});

export default router;   // ← ¡necesario!
