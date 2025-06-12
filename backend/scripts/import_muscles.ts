import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

interface MuscleData {
  name: string;
  portions: {
    name: string;
  }[];
}

async function importMuscles(muscles: MuscleData[]) {
  try {
    for (const muscle of muscles) {
      // Crear el músculo
      const newMuscle = await prisma.muscle.create({
        data: {
          name: muscle.name,
          portions: {
            create: muscle.portions.map(portion => ({
              name: portion.name,
              is_custom: false, // porciones importadas son globales
            }))
          }
        },
      });
    }

    console.log('Músculos importados exitosamente');
  } catch (error) {
    console.error('Error importando músculos:', error);
  } finally {
    await prisma.$disconnect();
  }
}

// Ejemplo de uso:
const musclesToImport: MuscleData[] = [
  {
    name: "Pectoral",
    portions: [
      { name: "Pectoral Superior" },
      { name: "Pectoral Medio" },
      { name: "Pectoral Inferior" }
    ]
  },
  {
    name: "Tríceps",
    portions: [
      { name: "Cabeza Larga" },
      { name: "Cabeza Lateral" },
      { name: "Cabeza Medial" }
    ]
  }
];

importMuscles(musclesToImport);
