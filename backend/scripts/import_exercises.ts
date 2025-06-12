import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

interface ExerciseData {
  name: string;
  description?: string;
  type?: string;
  seconds_duration?: number;
  muscle_portions: {
    muscle_portion_id: string;
    estimated_percentage: number;
  }[];
}

async function importExercises(exercises: ExerciseData[]) {
  try {
    for (const exercise of exercises) {
      // Verificar que las porciones musculares existan
      for (const portion of exercise.muscle_portions) {
        const existingPortion = await prisma.muscle_Portion.findUnique({
          where: { id: portion.muscle_portion_id }
        });
        if (!existingPortion) {
          throw new Error(`Porción muscular con ID ${portion.muscle_portion_id} no encontrada`);
        }
      }

      // Crear el ejercicio
      const newExercise = await prisma.exercise.create({
        data: {
          name: exercise.name,
          description: exercise.description,
          type: exercise.type,
          seconds_duration: exercise.seconds_duration,
          is_custom: false,
          Exercise_Muscle_Portion: {
            create: exercise.muscle_portions.map(portion => ({
              muscle_portion_id: portion.muscle_portion_id,
              estimated_percentage: portion.estimated_percentage
            }))
          }
        }
      });

      console.log(`Ejercicio ${exercise.name} creado con ID: ${newExercise.id}`);
    }

    console.log('Ejercicios importados exitosamente');
  } catch (error) {
    console.error('Error importando ejercicios:', error);
  } finally {
    await prisma.$disconnect();
  }
}

// Ejemplo de uso (reemplaza los IDs con los que obtuviste del script de músculos)
const exercisesToImport: ExerciseData[] = [
  {
    name: "Press de Banca",
    description: "Ejercicio para pecho con barra",
    type: "strength",
    seconds_duration: 60,
    muscle_portions: [
      {
        muscle_portion_id: "556e74e2-6abc-4960-b021-7ca67a6e7828", 
        estimated_percentage: 80
      },
      {
        muscle_portion_id: "405fc881-8490-49df-894e-ba33b1d81fe8", 
        
        estimated_percentage: 20
      }
    ]
  }
];

importExercises(exercisesToImport);