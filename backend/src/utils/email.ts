import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS,
  },
});
export const sendResetEmail = async (to: string, code: string) => {
  await transporter.sendMail({
    from: `"CoachFit" <${process.env.GMAIL_USER}>`,
    to,
    subject: 'Código de recuperación de contraseña',
    html: `
      <div style="font-family: Arial, sans-serif; font-size: 16px;">
        <h2 style="color: #ff3c00;">Recupera tu contraseña</h2>
        <p>Utiliza el siguiente código para restablecer tu contraseña:</p>
        
        <div style="margin: 20px 0; text-align: center;">
          <input 
            type="text" 
            value="${code}" 
            readonly 
            style="
              font-size: 24px;
              padding: 10px 20px;
              text-align: center;
              border: 2px solid #ff3c00;
              border-radius: 8px;
              background-color: #fefefe;
              color: #333;
              letter-spacing: 4px;
            "
            onclick="this.select(); document.execCommand('copy');"
          />
          <p style="font-size: 14px; color: #666;">Haz clic en el código para copiarlo</p>
        </div>

        <p>Este código expirará en 15 minutos.</p>
        <p style="color: #888;">Si no solicitaste este cambio, puedes ignorar este mensaje.</p>
      </div>
    `,
  });
};
