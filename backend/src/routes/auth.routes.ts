import express from 'express';
import { validate } from '../middlewares/validate'; // Middleware de validación
import { registerUser,loginUser, requestResetPassword, resetPassword, verifyResetCode, changePassword } from '../controllers/auth.controller';
import { registerUserSchema,loginUserSchema,requestResetSchema, resetPasswordSchema, verifyCodeSchema, changePasswordSchema } from '../validators/auth.validator';
import { request } from 'http';
import { requireAuth } from '../middlewares/requireAuth';

const router = express.Router();

router.post('/login', validate(loginUserSchema), loginUser); 
router.post('/register', validate(registerUserSchema), registerUser)
router.post('/request-reset', validate(requestResetSchema), requestResetPassword); 
router.post('/reset-password', validate(resetPasswordSchema), resetPassword);
router.post('/verify-code', validate(verifyCodeSchema), verifyResetCode);
router.post('/change-password',requireAuth, validate(changePasswordSchema), changePassword); 


/*
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
