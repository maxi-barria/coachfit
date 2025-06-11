import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './middlewares/auth';
import publicRoutes from './routes/public';
import { registerRoutes } from './routes';
import routineRoutes from './routes/routine.routes';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/auth', authRoutes);
app.use(publicRoutes);
registerRoutes(app);
app.use('/routines', routineRoutes);

app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});
