import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {

  await prisma.exercise_Muscle_Portion.deleteMany();
  await prisma.exercise.deleteMany();
  await prisma.muscle_Portion.deleteMany();
  await prisma.muscle.deleteMany();


  const muscles = await prisma.muscle.createMany({
    data: [
      { name: 'Pecho' },
      { name: 'Espalda' },
      { name: 'Pierna' },
    ],
  });


  // Recupera músculos con sus IDs
  const pecho = await prisma.muscle.findFirst({ where: { name: 'Pecho' } });
  const espalda = await prisma.muscle.findFirst({ where: { name: 'Espalda' } });
  const pierna = await prisma.muscle.findFirst({ where: { name: 'Pierna' } });

  // Porciones base
  await prisma.muscle_Portion.createMany({
    data: [
      { name: 'Pectoral mayor', muscle_id: pecho!.id },
      { name: 'Pectoral menor', muscle_id: pecho!.id },
      { name: 'Dorsal ancho', muscle_id: espalda!.id },
      { name: 'Trapecio', muscle_id: espalda!.id },
      { name: 'Cuádriceps', muscle_id: pierna!.id },
      { name: 'Isquiotibiales', muscle_id: pierna!.id },
    ],
  });
  console.log(' Porciones creadas');

  // Ejercicios globales de ejemplo (opcionales)
  await prisma.exercise.createMany({
    data: [
      { name: 'Push-up', type: 'bodyweight', is_custom: false },
      { name: 'Pull-up', type: 'bodyweight', is_custom: false },
      { name: 'Squat', type: 'bodyweight', is_custom: false },
    ],
  });
  console.log(' Ejercicios globales creados');
}

main()
  .then(() => {
    console.log(' Seed finalizado');
    return prisma.$disconnect();
  })
  .catch((e) => {
    console.error(e);
    return prisma.$disconnect();
  });
