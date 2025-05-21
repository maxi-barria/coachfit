import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/auth';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// monta todas las rutas de auth ⇒ POST /auth/login
app.use('/auth', authRoutes);

app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});
