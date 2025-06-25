// tests/setup.ts
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

beforeAll(async () => {
  // Opcional: preparar datos comunes
  await prisma.user.deleteMany(); // limpia antes de comenzar
});

afterEach(async () => {
  // Limpieza entre cada test si necesitas estado limpio siempre
  await prisma.user.deleteMany();
});

afterAll(async () => {
  // Cierra la conexión con la base de datos al terminar todos los tests
  await prisma.$disconnect();
});
