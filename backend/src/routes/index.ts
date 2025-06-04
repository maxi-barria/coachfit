// src/routes/index.ts
import { Express } from 'express'
import exerciseRoutes from './exercise.routes'

export function registerRoutes(app: Express) {
  app.use('/exercises', exerciseRoutes)
}
