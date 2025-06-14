import { PrismaClient, Prisma } from '@prisma/client';



const prisma = new PrismaClient();

export class CoachClientService {
    async getAll(coachId: string) {
        return await prisma.coachClient.findMany({
            where: { coachId },
            include: {
                client: {
                    select: {
                        id: true,
                        email: true,
                    },
                },
            },
        });
    }

    async create(data: {
        coachId: string;
        clientId: string;
        note?: string;
        startDate: Date;
        endDate?: Date;
    }) {
        return await prisma.coachClient.create({ data });
    }

    async update(id: string, data: Prisma.CoachClientUpdateInput) {
        return await prisma.coachClient.update({
            where: { id },
            data,
        });
    }



    async delete(id: string) {
        return await prisma.coachClient.delete({ where: { id } });
    }

    async getById(id: string) {
        return await prisma.coachClient.findUnique({
            where: { id },
            include: {
                client: true,
                coach: true,
            },
        });
    }
}
