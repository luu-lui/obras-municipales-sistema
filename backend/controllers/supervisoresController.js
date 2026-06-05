const db = require('../config/db');

exports.getAll = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM supervisores');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo supervisores' });
  }
};

exports.getById = async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM supervisores WHERE id = ?',
      [req.params.id]
    );

    if (!rows.length) {
      return res.status(404).json({ error: 'Supervisor no encontrado' });
    }

    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo supervisor' });
  }
};

exports.create = async (req, res) => {
  try {
    const { nombre, cargo, telefono, correo } = req.body || {};

    if (!nombre || !cargo || !telefono || !correo) {
      return res.status(400).json({
        error: 'Nombre, cargo, teléfono y correo son obligatorios'
      });
    }

    const [result] = await db.query(
      'INSERT INTO supervisores (nombre, cargo, telefono, correo) VALUES (?, ?, ?, ?)',
      [nombre, cargo, telefono, correo]
    );

    res.status(201).json({
      message: 'Supervisor creado',
      id: result.insertId
    });
  } catch (error) {
    res.status(500).json({ error: 'Error creando supervisor' });
  }
};

exports.update = async (req, res) => {
  try {
    const { nombre, cargo, telefono, correo } = req.body || {};

    if (!nombre || !cargo || !telefono || !correo) {
      return res.status(400).json({
        error: 'Nombre, cargo, teléfono y correo son obligatorios'
      });
    }

    const [result] = await db.query(
      'UPDATE supervisores SET nombre = ?, cargo = ?, telefono = ?, correo = ? WHERE id = ?',
      [nombre, cargo, telefono, correo, req.params.id]
    );

    if (!result.affectedRows) {
      return res.status(404).json({ error: 'Supervisor no encontrado' });
    }

    res.json({ message: 'Supervisor actualizado' });
  } catch (error) {
    res.status(500).json({ error: 'Error actualizando supervisor' });
  }
};

exports.remove = async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM supervisores WHERE id = ?',
      [req.params.id]
    );

    if (!result.affectedRows) {
      return res.status(404).json({ error: 'Supervisor no encontrado' });
    }

    res.json({ message: 'Supervisor eliminado' });
  } catch (error) {
    res.status(500).json({ error: 'Error eliminando supervisor' });
  }
};