// src/routes/index.ts
import { Express } from 'express'
import exerciseRoutes from './exercise.routes'
import authRoutes from './auth.routes'
import routineRoutes from './routine.routes'

export function registerRoutes(app: Express) {
  app.use('/auth', authRoutes)
  app.use('/exercises', exerciseRoutes)
  app.use('/routines', routineRoutes)
}
