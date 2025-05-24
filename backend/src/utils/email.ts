import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS,
  },
});

export const sendResetEmail = async (to: string, token: string) => {
  // ✅ Usamos un link clickeable que redirige a la app
  const resetLink = `https://coachfit-backend.onrender.com/open-app?token=${token}`;

  await transporter.sendMail({
    from: `"CoachFit" <${process.env.GMAIL_USER}>`,
    to,
    subject: 'Recuperación de contraseña',
    html: `
      <div style="font-family: Arial, sans-serif; font-size: 16px;">
        <h2 style="color: #ff3c00;">Recupera tu contraseña</h2>
        <p>Haz clic en el siguiente botón para restablecerla:</p>
        <p>
          <a href="${resetLink}" target="_blank" style="
            display: inline-block;
            padding: 12px 24px;
            background-color: #ff3c00;
            color: white;
            text-decoration: none;
            border-radius: 6px;
          ">
            Restablecer contraseña
          </a>
        </p>
        <p style="margin-top: 20px;">Si no funciona el botón, también puedes copiar y pegar este enlace en tu navegador:</p>
        <p style="color: #555;">${resetLink}</p>
        <p>Este enlace expirará en 15 minutos.</p>
      </div>
    `,
  });
};
