const express = require('express');
const router = express.Router();

// Ruta GET: http://localhost:3000/users
router.get('/', (req, res) => {
  res.send('Lista de usuarios');
});

// Ruta POST: http://localhost:3000/users
router.post('/', (req, res) => {
  const { name } = req.body;
  res.send(`Usuario ${name} creado`);
});

module.exports = router;
