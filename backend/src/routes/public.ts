import { Router, Request, Response } from 'express';

const router = Router();

router.get('/open-app', (req: Request, res: Response) => {
  const { token } = req.query;

  if (!token || typeof token !== 'string') {
    res.status(400).send('<h3>Token inválido</h3>');
    return;
  }

  res.set('Content-Type', 'text/html');
  res.send(`
    <!DOCTYPE html>
    <html lang="es">
      <head>
        <meta charset="UTF-8" />
        <title>Redirigiendo a CoachFit</title>
        <script>
          window.location.href = "coachfit://reset-password?token=${token}";
        </script>
      </head>
      <body>
        <p>Redirigiendo a CoachFit...</p>
        <p>Si no pasa nada, asegúrate de tener la app instalada.</p>
      </body>
    </html>
  `);
});

export default router;
