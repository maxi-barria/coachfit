import express, { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { comparePassword, hashPassword } from '../utils/hash';
import { generateToken } from '../utils/jwt';
import { v4 as uuidv4 } from 'uuid';
import { sendResetEmail } from '../utils/email';
import bcrypt from 'bcrypt';
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

router.post('/request-reset', async (req: Request, res: Response): Promise<void> => {
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

  const token = uuidv4();
  const expiry = new Date(Date.now() + 15 * 60 * 1000); // 15 minutos

  await prisma.user.update({
    where: { email },
    data: {
      resetToken: token,
      resetTokenExpiry: expiry,
    },
  });

  try {
    // ✅ Le pasamos solo el token
    await sendResetEmail(email, token);
    res.json({ message: 'Correo de recuperación enviado.' });
  } catch (err) {
    console.error('Error enviando correo:', err);
    res.status(500).json({ message: 'Error al enviar el correo.' });
  }
});


router.post('/reset-password', async (req: Request, res: Response) : Promise<void> => {
  const { token, password, confirmPassword } = req.body;

  if (!token || !password || !confirmPassword) {
    res.status(400).json({ message: 'Todos los campos son obligatorios.' });
    return 
  }
  if (password !== confirmPassword) {
    res.status(400).json({ message: 'Las contraseñas no coinciden.' });
    return;
  }

  const user = await prisma.user.findFirst({
    where: {
      resetToken: token,
      resetTokenExpiry: { gte: new Date() }, // solo tokens válidos
    },
  });

  if (!user) {
    res.status(400).json({ message: 'Token inválido o expirado' });
    return 
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  await prisma.user.update({
    where: { id: user.id },
    data: {
      password: hashedPassword,
      resetToken: null,
      resetTokenExpiry: null,
    },
  });

  res.status(200).json({ message: 'Contraseña actualizada correctamente' });
});

router.get('/open-app', (req: Request, res: Response) => {
  const { token } = req.query;

  if (!token || typeof token !== 'string') {
    res.status(400).send('<h3>Token inválido</h3>');
    return;
  }

  res.set('Content-Type', 'text/html');
  res.send(`
    <!DOCTYPE html>
    <html lang="es">
      <head>
        <meta charset="UTF-8">
        <title>Redirigiendo a CoachFit</title>
        <style>
          body { font-family: Arial, sans-serif; text-align: center; padding-top: 50px; }
        </style>
        <script>
          window.onload = function() {
            const token = "${token}";
            window.location.href = "coachfit://reset-password?token=" + token;
          }
        </script>
      </head>
      <body>
        <p>Abriendo CoachFit...</p>
        <p>Si no pasa nada, asegúrate de tener la app instalada.</p>
      </body>
    </html>
  `);
});



export default router;   // ← ¡necesario!
