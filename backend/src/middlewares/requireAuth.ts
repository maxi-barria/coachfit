import { RequestHandler } from 'express';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'secret';

/** Protege rutas con JWT en Authorization */
export const requireAuth: RequestHandler = (req, res, next) => {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    res.status(401).json({ message: 'Unauthorized' });
    return;
  }

  const token = header.split(' ')[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET) as { id: string; rol: string };
    req.user = {
      id: payload.id,
      rol: payload.rol
    };
    next();
  } catch (err) {
    res.status(401).json({ message: 'Invalid token' });
  }
};
