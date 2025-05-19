import express, { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { comparePassword } from '../utils/hash';
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


export default router;   // ← ¡necesario!
