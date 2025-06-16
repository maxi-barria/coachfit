// src/services/coachClient.service.ts
import { PrismaClient, Prisma } from '@prisma/client'

const prisma = new PrismaClient()

export class CoachClientService {
    /* -------- LIST (por coach) --------------------- */
    async getAll(coachId: string) {
        return prisma.coachClient.findMany({
            where: { coachId },
            include: {
                client: { select: { id: true, email: true } },
            },
            orderBy: { startDate: 'desc' },
        })
    }

    /* -------- CREATE ------------------------------- */
    async create(data: {
        coachId: string
        clientId: string
        note?: string
        startDate: Date
        endDate?: Date | null
    }) {
        // evita duplicados
        const exists = await prisma.coachClient.findUnique({
            where: { coachId_clientId: { coachId: data.coachId, clientId: data.clientId } },
        })
        if (exists) throw new Error('Ya existe relación con este cliente')

        return prisma.coachClient.create({ data })
    }

    /* -------- UPDATE ------------------------------- */
    async update(id: string, data: Prisma.CoachClientUpdateInput) {
        try {
            return await prisma.coachClient.update({ where: { id }, data })
        } catch (err: any) {
            if (err.code === 'P2025') return null // no encontrado
            throw err
        }
    }

    /* -------- DELETE ------------------------------- */
    async delete(id: string) {
        try {
            await prisma.coachClient.delete({ where: { id } })
        } catch (err: any) {
            if (err.code === 'P2025')
                throw new Error('La relación coach-cliente ya no existe.')
            throw err
        }
    }

    /* -------- GET BY ID ---------------------------- */
    async getById(id: string) {
        return prisma.coachClient.findUnique({
            where: { id },
            include: {
                client: { select: { id: true, email: true, rol: true } },
                coach: { select: { id: true, email: true } },
            },
        })
    }
}
