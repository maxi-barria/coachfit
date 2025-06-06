// src/types/express/index.d.ts
import { User } from '@prisma/client' // o define el tipo manualmente
import * as express from 'express';
declare global {
  namespace Express {
    interface Request {
      user?: { id: string,
        rol: string
      }
      
    }
  }
}
export {};