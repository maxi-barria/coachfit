import request from 'supertest';// libreira para simular preticiones HTTP
import app from '../../../src/app'; // Asegúrate de que la ruta sea correcta
import { PrismaClient } from '@prisma/client';// se importa PrismaClient para interactuar con la base de datos
import { describe } from 'node:test';
import { hashPassword } from '../../../src/utils/hash';
import { generateUniqueEmail } from '../utils/testHelper';
import jwt from 'jsonwebtoken';
const prisma = new PrismaClient();
//Se agrupan los tests relacionados con el register


describe('POST /auth/register', () => {
    const baseUrl = '/auth/register';


    afterAll(async () => {
        await prisma.user.deleteMany({
            where: {
                email: { contains: '+' },
            },
        });
        await prisma.$disconnect();
    });

    //Se define test individual
    it('debería registrar un nuevo usuario exitosamente', async () => {
        const email = generateUniqueEmail('register');
        const res = await request(app).post(baseUrl).send({
            email: email,
            password: 'Password123!',
            confirmPassword: 'Password123!',
            rol: 'client',
        });
        expect(res.status).toBe(201);
        expect(res.body).toHaveProperty('token');
        expect(res.body.user).toMatchObject({
            email: email,
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
        const uniqueEmail = `test+${Date.now()}@example.com`;

        await prisma.user.create({
            data: {
                email: uniqueEmail,
                password: await hashPassword('Password123!'),
                rol: 'client',
            }
        });
        const res = await request(app).post(baseUrl).send({
            email: uniqueEmail,
            password: 'Password123!',
            confirmPassword: 'Password123!',
            rol: 'client',
        });
        expect(res.status).toBe(409);
        expect(res.body.message).toContain('El Correo ya está en uso.');
    });
});

describe('POST /auth/login', () => {
    const baseUrl = '/auth/login';
    beforeEach(async () => {
        // Limpia antes de cada test
        await prisma.user.deleteMany({ where: { email: 'test@example.com' } });

        // Crea un usuario válido
        await prisma.user.create({
            data: {
                email: 'test@example.com',
                password: await hashPassword('Password123!'), // Usa el mismo hash del controller
                rol: 'client',
            },
        });
    });
    afterAll(async () => {
        await prisma.user.deleteMany({
            where: {
                email: { contains: '+' },
            },
        });
        await prisma.$disconnect();
    });
    it('debería iniciar sesión exitosamente con credenciales válidas', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'test@example.com',
            password: 'Password123!',
        });
        expect(res.status).toBe(200);
        expect(res.body).toHaveProperty('token');
        expect(res.body.user).toMatchObject({
            id: expect.any(String),
            email: 'test@example.com',
            rol: 'client'
        });
        expect(res.body.message).toContain('Inicio de sesión exitoso.');
    });
    it('debería fallar si las credenciales son incorrectas', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'test@example.com',
            password: 'WrongPassword1!',
        });
        expect(res.status).toBe(401);
        expect(res.body.message).toContain('Correo o contraseña incorrecto.');
    });
    it('debería fallar si el usuario no existe', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'test@example.cl',
            password: 'Password123!',
        });
        expect(res.status).toBe(404);
        expect(res.body.message).toContain('Usuario no encontrado.');
    });
}
);


describe('POST /auth/request-reset', () => {
    const baseUrl = '/auth/request-reset';

    beforeEach(async () => {
        await prisma.user.deleteMany({ where: { email: 'maxi.nevens.20021@gmail.com' } });

        await prisma.user.create({
            data: {
                email: 'maxi.nevens.20021@gmail.com',
                password: 'Password123!', // No importa aquí
                rol: 'client',
            },
        });
    });

    afterAll(async () => {
        await prisma.$disconnect();
    });

    it('debería enviar el código si el usuario existe', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'maxi.nevens.20021@gmail.com',
        });

        expect(res.status).toBe(200);
        expect(res.body.message).toContain('Correo de recuperación enviado.');
    });

    it('debería responder igual aunque el correo no exista (por seguridad)', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'noexiste@example.com',
        });

        expect(res.status).toBe(200);
        expect(res.body.message).toContain('Si el correo existe, se ha enviado un enlace.');
    });

    it('debería fallar si no se envía el correo', async () => {
        const res = await request(app).post(baseUrl).send({});
        expect(res.body.errors[0].field).toBe('email');
        expect(res.body.errors[0].message).toContain('Required');
    });
});


describe('POST /auth/verify-code', () => {
    const baseUrl = '/auth/verify-code';
    const email = 'verify+test@example.com';
    const validCode = '123456';

    beforeEach(async () => {
        await prisma.user.deleteMany({ where: { email } });

        await prisma.user.create({
            data: {
                email,
                password: 'Password123!',
                rol: 'client',
                resetToken: validCode,
                resetTokenExpiry: new Date(Date.now() + 15 * 60 * 1000), // 15 minutos después
            },
        });
    });

    afterAll(async () => {
        await prisma.user.deleteMany({ where: { email } });
        await prisma.$disconnect();
    });

    it('debería validar el código correctamente', async () => {
        const res = await request(app).post(baseUrl).send({ email, code: validCode });

        expect(res.status).toBe(200);
        expect(res.body.message).toContain('Código válido');
    });

    it('debería fallar con código incorrecto', async () => {
        const res = await request(app).post(baseUrl).send({ email, code: '999999' });

        expect(res.status).toBe(400);
        expect(res.body.message).toContain('Código inválido');
    });

    it('debería fallar si el código expiró', async () => {
        await prisma.user.update({
            where: { email },
            data: {
                resetTokenExpiry: new Date(Date.now() - 1000), // hace 1 segundo
            },
        });

        const res = await request(app).post(baseUrl).send({ email, code: validCode });

        expect(res.status).toBe(410); // o 400 si prefieres
        expect(res.body.message).toContain('expirado');
    });

    it('debería fallar si el usuario no existe', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'noexiste@example.com',
            code: validCode,
        });

        expect(res.status).toBe(404);
        expect(res.body.message).toContain('Usuario no encontrado');
    });

    it('debería fallar si faltan campos', async () => {
        const res = await request(app).post(baseUrl).send({});

        expect(res.status).toBe(400);
        expect(res.body.errors[0].field).toBe('email'); // y/o 'code'
    });
});


describe('POST /auth/reset-password', () => {
    const baseUrl = '/auth/reset-password';
    const email = 'reset+test@example.com';
    const correctCode = '123456';

    beforeEach(async () => {
        await prisma.user.deleteMany({ where: { email } });

        await prisma.user.create({
            data: {
                email,
                password: await hashPassword('OldPassword123!'),
                rol: 'client',
                resetToken: correctCode,
                resetTokenExpiry: new Date(Date.now() + 15 * 60 * 1000), // válido 15 min
            },
        });
    });

    afterAll(async () => {
        await prisma.$disconnect();
    });

    it('debería cambiar la contraseña exitosamente', async () => {
        const res = await request(app).post(baseUrl).send({
            email,
            code: correctCode,
            password: 'NuevaPassword123!',
            confirmPassword: 'NuevaPassword123!',
        });

        expect(res.status).toBe(200);
        expect(res.body.message).toContain('Contraseña actualizada correctamente');
    });

    it('debería fallar si el código es incorrecto', async () => {
        const res = await request(app).post(baseUrl).send({
            email,
            code: '999999',
            password: 'NuevaPassword123!',
            confirmPassword: 'NuevaPassword123!',
        });

        expect(res.status).toBe(400);
        expect(res.body.message).toContain('Código inválido');
    });

    it('debería fallar si el código ha expirado', async () => {
        await prisma.user.update({
            where: { email },
            data: { resetTokenExpiry: new Date(Date.now() - 1000) }, // expirado
        });

        const res = await request(app).post(baseUrl).send({
            email,
            code: correctCode,
            password: 'NuevaPassword123!',
            confirmPassword: 'NuevaPassword123!',
        });

        expect(res.status).toBe(410);
        expect(res.body.message).toContain('expirado');
    });

    it('debería fallar si el usuario no existe', async () => {
        const res = await request(app).post(baseUrl).send({
            email: 'noexiste@example.com',
            code: correctCode,
            password: 'NuevaPassword123!',
            confirmPassword: 'NuevaPassword123!',
        });

        expect(res.status).toBe(404);
        expect(res.body.message).toContain('Usuario no encontrado');
    });

    it('debería fallar si las contraseñas no coinciden', async () => {
        const res = await request(app).post(baseUrl).send({
            email,
            code: correctCode,
            password: 'NuevaPassword123!',
            confirmPassword: 'OtraPassword123!',
        });

        expect(res.status).toBe(400);
        expect(res.body.errors[0].message).toContain('no coinciden');
    });

    it('debería fallar si falta algún campo', async () => {
        const res = await request(app).post(baseUrl).send({
            email,
            code: correctCode,
            password: 'NuevaPassword123!',
        });

        expect(res.status).toBe(400);
        expect(res.body.errors[0].field).toBe('confirmPassword');
    });
});
describe('POST /auth/change-password', () => {
    const email = 'change@example.com';
    const oldPassword = 'OldPassword123!';
    const newPassword = 'NuevaPassword123!';
    let token: string;

    beforeEach(async () => {
        await prisma.user.deleteMany({ where: { email } });

        const hashed = await hashPassword(oldPassword);
        const user = await prisma.user.create({
            data: {
                email,
                password: hashed,
                rol: 'client',
            },
        });

        // Generar token manual (simula login)
        token = jwt.sign({ id: user.id, rol: user.rol }, process.env.JWT_SECRET as string, {
            expiresIn: '1h',
        });
    });

    afterAll(async () => {
        await prisma.$disconnect();
    });

    it('debería cambiar la contraseña correctamente', async () => {
        const res = await request(app)
            .post('/auth/change-password')
            .set('Authorization', `Bearer ${token}`)
            .send({
                currentPassword: oldPassword,
                newPassword:newPassword,
                confirmNewPassword: newPassword,
            });
        expect(res.status).toBe(200);
        expect(res.body.message).toContain('Contraseña actualizada correctamente');
    });

    it('debería fallar si la contraseña actual es incorrecta', async () => {
        const res = await request(app)
            .post('/auth/change-password')
            .set('Authorization', `Bearer ${token}`)
            .send({
                currentPassword: 'WrongPass123!',
                newPassword,
                confirmNewPassword: newPassword,
            });

        expect(res.status).toBe(401);
        expect(res.body.message).toContain('incorrecta');
    });

    it('debería fallar si las nuevas contraseñas no coinciden', async () => {
        const res = await request(app)
            .post('/auth/change-password')
            .set('Authorization', `Bearer ${token}`)
            .send({
                currentPassword: oldPassword,
                newPassword,
                confirmNewPassword: 'OtraPassword123!',
            });

        expect(res.status).toBe(400);
        expect(res.body.errors[0].message).toContain('Las nuevas contraseñas no coinciden.');
    });

    it('debería fallar si no hay token', async () => {
        const res = await request(app).post('/auth/change-password').send({
            currentPassword: oldPassword,
            newPassword,
            confirmPassword: newPassword,
        });

        expect(res.status).toBe(401);
        expect(res.body.message).toContain('Unauthorized');
    });
});