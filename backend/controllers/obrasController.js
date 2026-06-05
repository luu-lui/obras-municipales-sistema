const db = require('../config/db');

exports.getAll = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        o.*,
        c.nombre AS contratista_nombre,
        s.nombre AS supervisor_nombre
      FROM obras o
      JOIN contratistas c ON o.contratista_id = c.id
      JOIN supervisores s ON o.supervisor_id = s.id
    `);

    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo obras' });
  }
};

exports.getById = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        o.*,
        c.nombre AS contratista_nombre,
        s.nombre AS supervisor_nombre
      FROM obras o
      JOIN contratistas c ON o.contratista_id = c.id
      JOIN supervisores s ON o.supervisor_id = s.id
      WHERE o.id = ?
    `, [req.params.id]);

    if (!rows.length) {
      return res.status(404).json({ error: 'Obra no encontrada' });
    }

    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo obra' });
  }
};

exports.getByEstado = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        o.*,
        c.nombre AS contratista_nombre,
        s.nombre AS supervisor_nombre
      FROM obras o
      JOIN contratistas c ON o.contratista_id = c.id
      JOIN supervisores s ON o.supervisor_id = s.id
      WHERE o.estado = ?
    `, [req.params.estado]);

    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Error filtrando obras por estado' });
  }
};

exports.reporte = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        COUNT(*) AS total_obras,
        SUM(presupuesto) AS presupuesto_total,
        AVG(presupuesto) AS presupuesto_promedio
      FROM obras
    `);

    res.json({
      total_obras: rows[0].total_obras || 0,
      presupuesto_total: Number(rows[0].presupuesto_total || 0),
      presupuesto_promedio: Number(rows[0].presupuesto_promedio || 0)
    });
  } catch (error) {
    res.status(500).json({ error: 'Error generando reporte de obras' });
  }
};

exports.create = async (req, res) => {
  try {
    const {
      nombre,
      tipo,
      ubicacion,
      presupuesto,
      estado,
      fecha_inicio,
      fecha_fin,
      contratista_id,
      supervisor_id
    } = req.body || {};

    if (!nombre || !tipo || !ubicacion || !presupuesto || !contratista_id || !supervisor_id) {
      return res.status(400).json({
        error: 'Nombre, tipo, ubicación, presupuesto, contratista y supervisor son obligatorios'
      });
    }

    const [result] = await db.query(
      `INSERT INTO obras 
      (nombre, tipo, ubicacion, presupuesto, estado, fecha_inicio, fecha_fin, contratista_id, supervisor_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        nombre,
        tipo,
        ubicacion,
        presupuesto,
        estado || 'planificada',
        fecha_inicio || null,
        fecha_fin || null,
        contratista_id,
        supervisor_id
      ]
    );

    res.status(201).json({ message: 'Obra creada', id: result.insertId });
  } catch (error) {
    res.status(500).json({ error: 'Error creando obra' });
  }
};

exports.update = async (req, res) => {
  try {
    const {
      nombre,
      tipo,
      ubicacion,
      presupuesto,
      estado,
      fecha_inicio,
      fecha_fin,
      contratista_id,
      supervisor_id
    } = req.body || {};

    if (!nombre || !tipo || !ubicacion || !presupuesto || !contratista_id || !supervisor_id) {
      return res.status(400).json({
        error: 'Nombre, tipo, ubicación, presupuesto, contratista y supervisor son obligatorios'
      });
    }

    const [result] = await db.query(
      `UPDATE obras 
       SET nombre = ?, tipo = ?, ubicacion = ?, presupuesto = ?, estado = ?, fecha_inicio = ?, fecha_fin = ?, contratista_id = ?, supervisor_id = ?
       WHERE id = ?`,
      [
        nombre,
        tipo,
        ubicacion,
        presupuesto,
        estado || 'planificada',
        fecha_inicio || null,
        fecha_fin || null,
        contratista_id,
        supervisor_id,
        req.params.id
      ]
    );

    if (!result.affectedRows) {
      return res.status(404).json({ error: 'Obra no encontrada' });
    }

    res.json({ message: 'Obra actualizada' });
  } catch (error) {
    res.status(500).json({ error: 'Error actualizando obra' });
  }
};

exports.remove = async (req, res) => {
  try {
    const [result] = await db.query('DELETE FROM obras WHERE id = ?', [req.params.id]);

    if (!result.affectedRows) {
      return res.status(404).json({ error: 'Obra no encontrada' });
    }

    res.json({ message: 'Obra eliminada' });
  } catch (error) {
    res.status(500).json({ error: 'Error eliminando obra' });
  }
};