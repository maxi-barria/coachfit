import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.GMAIL_USER,
        pass: process.env.GMAIL_PASS,
    },
});
export const sendResetEmail = async (to: string, resetLink: string) => {
  await transporter.sendMail({
    from: `"CoachFit" <${process.env.GMAIL_USER}>`,
    to,
    subject: 'Recuperación de contraseña',
    html: `
      <h2>Recuperar tu contraseña</h2>
      <p>Haz clic en el siguiente enlace para restablecerla:</p>
      <a href="${resetLink}">${resetLink}</a>
      <p>Este enlace expirará en 15 minutos.</p>
    `,
  });
};