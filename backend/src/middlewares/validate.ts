import {z} from 'zod';
import {Request, Response, NextFunction} from 'express';

//Se crea función de validación que recibe un esquema Zod
                                                 // esta es la función que se exporta
export const validate = (schema: z.ZodSchema) => (req: Request, res: Response, next: NextFunction) => {
    const result = schema.safeParse(req.body);// Se valida el cuerpo de la solicitud con el esquema Zod
    // safeParse devuelve un objeto con success y error si hay errores de validación
    // success es true si la validación fue exitosa, false si hubo errores
    if (!result.success) {
        res.status(400).json({
        errors: result.error.errors.map((e) => ({
            field: e.path[0],
            message: e.message,
        })),
        });
        return;
    }
        req.body = result.data; // Optional: replace req.body with parsed data
        next();
    };