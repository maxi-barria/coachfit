import request from 'supertest';// libreira para simular preticiones HTTP
import app from '../../../src/app'; // Asegúrate de que la ruta sea correcta
import { PrismaClient } from '@prisma/client';// se importa PrismaClient para interactuar con la base de datos

const prisma = new PrismaClient();
//Se agrupan los tests relacionados con el register


describe('POST /auth/register', () => {
    const baseUrl = '/auth/register';
    beforeEach(async () => {
        await prisma.user.deleteMany({ where: { email: { in: ['test@example.com', 'test2@example.com'] } } });
    });
    beforeAll(async () => {
        // Opcional: limpiar DB antes de tests
        await prisma.user.deleteMany({ where: { email: 'test@example.com' } });
    });
    afterAll(async () => {
  await prisma.$disconnect(); 
});

    //Se define test individual
    it('debería registrar un nuevo usuario exitosamente', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'test@example.com',
            password: 'Password123!',
            confirmPassword: 'Password123!',
            rol: 'client',
        });
        expect(res.status).toBe(201);
        expect(res.body).toHaveProperty('token');
        expect(res.body.user).toMatchObject({
            email: 'test@example.com',
            rol: 'client'
        });
    });
    it('debería fallar si las contraseñas no coinciden', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'test2@example.com',
            password: 'Password123!',
            confirmPassword: 'Password321!',
            rol: 'client',
        });
        expect(res.status).toBe(400);
        expect(res.body.errors[0].message).toContain('Las contraseñas no coinciden.');
    });
    it('debería fallar si el email ya está en uso', async () => {
        await prisma.user.create({
            data: {
                email: 'test@example.com',
                password: 'Password123!',
                rol: 'client',
            }
        });
        const res = await request(app).post(baseUrl).send({
            email: 'test@example.com',
            password: 'Password123!',
            confirmPassword: 'Password123!',
            rol: 'client',
        });
        expect(res.status).toBe(409);
        expect(res.body.message).toContain('El Correo ya está en uso.');
    });
});

export default app;