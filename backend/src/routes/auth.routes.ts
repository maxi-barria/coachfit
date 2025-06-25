import express from 'express';
import { validate } from '../middlewares/validate'; // Middleware de validación
import { registerUser } from '../controllers/auth.controller';
import { registerUserSchema } from '../validators/auth.validator';





const router = express.Router();

/*
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

      // 🔥 Incluye el rol en el token
      const token = generateToken(user.id, user.rol);

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
*/

router.post('/register', validate(registerUserSchema), registerUser)// Middleware de validación

/*
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
    await sendResetEmail(email, token);
    res.json({ message: 'Correo de recuperación enviado.' });
  } catch (err) {
    console.error('Error enviando correo:', err);
    res.status(500).json({ message: 'Error al enviar el correo.' });
  }
});


router.post('/reset-password', async (req: Request, res: Response): Promise<void> => {
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
*/



export default router;   // ← ¡necesario!
