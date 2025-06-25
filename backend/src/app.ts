//Crea instanica de express
//habilita CORS (Cross-Origin Resource sharing) para que el frontend pueda hacer peticiones
// Carga variables de entorno desde un archivo .env
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';


import authRoutes from './routes/auth.routes';
import publicRoutes from './routes/public';
import { registerRoutes } from './routes';
import routineRoutes from './routes/routine.routes';
import workoutSessionRoutes from './routes/workoutSession.routes';
import progressRoutes from './routes/progress.routes';
import coachClientRoutes from './routes/coachClient.routes';

dotenv.config();// carga .env, como JWT_SECRET, DATABASE_URL etc

const app = express(); // Objeto que respresenta mi servidor web el cual está vacío
app.use(cors()); // Habilita CORS para que el frontend pueda hacer peticiones a este backend, esto se puede personalizar más adelante si es necesario
app.use(express.json());

// Rutas públicas y de autenticación
app.use('/auth', authRoutes); // registra middleware de autenticación
app.use(publicRoutes);

// Rutas protegidas registradas dinámicamente
registerRoutes(app);

// Rutas específicas
app.use('/routines', routineRoutes);
app.use('/workout-sessions', workoutSessionRoutes);
app.use('/progress', progressRoutes);
app.use('/coach-clients', coachClientRoutes);

// Servidor
export default app; // Exporta la instancia de Express para que pueda ser utilizada en otros archivos
app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});
