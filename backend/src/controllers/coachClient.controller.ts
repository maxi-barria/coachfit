import { Request, Response } from "express";
import { CoachClientService } from "../services/coachClient.service";

const service = new CoachClientService();

export class CoachClientController {
    async getAll(req: Request, res: Response) {
        try {
            const coachId = req.params.coachId;
            const clients = await service.getAll(coachId);
            res.json(clients);
        } catch (err) {
            res.status(500).json({ error: "Error al obtener clientes" });
        }
    }

    async create(req: Request, res: Response) {
        try {
            const data = req.body;
            const client = await service.create(data);
            res.status(201).json(client);
        } catch (err) {
            res.status(500).json({ error: "Error al crear relación coach-cliente" });
        }
    }

    async update(req: Request, res: Response) {
        try {
            const id = req.params.id;
            const updated = await service.update(id, req.body);
            res.json(updated);
        } catch (err) {
            res.status(500).json({ error: "Error al actualizar cliente" });
        }
    }

    async delete(req: Request, res: Response) {
        try {
            const id = req.params.id;
            await service.delete(id);
            res.status(204).send();
        } catch (err) {
            res.status(500).json({ error: "Error al eliminar cliente" });
        }
    }

    async getById(req: Request, res: Response) {
        try {
            const id = req.params.id;
            const client = await service.getById(id);
            res.json(client);
        } catch (err) {
            res.status(500).json({ error: "Error al obtener cliente" });
        }
    }
}
