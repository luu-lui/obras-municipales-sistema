const db = require('../config/db');

exports.getAll = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM contratistas');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo contratistas' });
  }
};

exports.getById = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM contratistas WHERE id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Contratista no encontrado' });
    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo contratista' });
  }
};

exports.create = async (req, res) => {
  try {
    const { nombre, ruc, telefono, correo, direccion } = req.body || {};

    if (!nombre || !ruc || !telefono || !correo) {
      return res.status(400).json({ error: 'Nombre, RUC, teléfono y correo son obligatorios' });
    }

    const [result] = await db.query(
      'INSERT INTO contratistas (nombre, ruc, telefono, correo, direccion) VALUES (?, ?, ?, ?, ?)',
      [nombre, ruc, telefono, correo, direccion || '']
    );

    res.status(201).json({ message: 'Contratista creado', id: result.insertId });
  } catch (error) {
    res.status(500).json({ error: 'Error creando contratista' });
  }
};

exports.update = async (req, res) => {
  try {
    const { nombre, ruc, telefono, correo, direccion } = req.body || {};

    if (!nombre || !ruc || !telefono || !correo) {
      return res.status(400).json({ error: 'Nombre, RUC, teléfono y correo son obligatorios' });
    }

    const [result] = await db.query(
      'UPDATE contratistas SET nombre = ?, ruc = ?, telefono = ?, correo = ?, direccion = ? WHERE id = ?',
      [nombre, ruc, telefono, correo, direccion || '', req.params.id]
    );

    if (!result.affectedRows) return res.status(404).json({ error: 'Contratista no encontrado' });

    res.json({ message: 'Contratista actualizado' });
  } catch (error) {
    res.status(500).json({ error: 'Error actualizando contratista' });
  }
};

exports.remove = async (req, res) => {
  try {
    const [result] = await db.query('DELETE FROM contratistas WHERE id = ?', [req.params.id]);
    if (!result.affectedRows) return res.status(404).json({ error: 'Contratista no encontrado' });
    res.json({ message: 'Contratista eliminado' });
  } catch (error) {
    res.status(500).json({ error: 'Error eliminando contratista' });
  }
};