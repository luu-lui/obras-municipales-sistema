const db = require('../config/db');

exports.login = async (req, res) => {
  try {
    const { usuario, contrasena } = req.body || {};

    if (!usuario || !contrasena) {
      return res.status(400).json({
        error: 'Usuario y contraseña obligatorios'
      });
    }

    const [rows] = await db.query(
      'SELECT * FROM usuarios WHERE usuario = ? AND contrasena = ?',
      [usuario, contrasena]
    );

    if (rows.length === 0) {
      return res.status(401).json({
        error: 'Credenciales incorrectas'
      });
    }

    res.json({
      mensaje: 'Login correcto',
      usuario: rows[0].usuario,
      rol: rows[0].rol
    });
  } catch (error) {
    res.status(500).json({
      error: error.message
    });
  }
};