const db = require('../config/db');

exports.getAll = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        a.*,
        o.nombre AS obra_nombre
      FROM avances a
      JOIN obras o ON a.obra_id = o.id
    `);

    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo avances' });
  }
};

exports.getById = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        a.*,
        o.nombre AS obra_nombre
      FROM avances a
      JOIN obras o ON a.obra_id = o.id
      WHERE a.id = ?
    `, [req.params.id]);

    if (!rows.length) {
      return res.status(404).json({ error: 'Avance no encontrado' });
    }

    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Error obteniendo avance' });
  }
};

exports.getByObra = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        a.*,
        o.nombre AS obra_nombre
      FROM avances a
      JOIN obras o ON a.obra_id = o.id
      WHERE a.obra_id = ?
      ORDER BY a.fecha DESC
    `, [req.params.obra_id]);

    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Error filtrando avances por obra' });
  }
};

exports.create = async (req, res) => {
  try {
    const {
      obra_id,
      fecha,
      porcentaje,
      descripcion,
      gasto_ejecutado,
      observaciones
    } = req.body || {};

    if (!obra_id || !fecha || porcentaje === undefined || !descripcion) {
      return res.status(400).json({
        error: 'Obra, fecha, porcentaje y descripción son obligatorios'
      });
    }

    if (porcentaje < 0 || porcentaje > 100) {
      return res.status(400).json({
        error: 'El porcentaje debe estar entre 0 y 100'
      });
    }

    const [result] = await db.query(
      `INSERT INTO avances 
      (obra_id, fecha, porcentaje, descripcion, gasto_ejecutado, observaciones)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [
        obra_id,
        fecha,
        porcentaje,
        descripcion,
        gasto_ejecutado || 0,
        observaciones || ''
      ]
    );

    res.status(201).json({
      message: 'Avance registrado',
      id: result.insertId
    });
  } catch (error) {
    res.status(500).json({ error: 'Error registrando avance' });
  }
};

exports.update = async (req, res) => {
  try {
    const {
      obra_id,
      fecha,
      porcentaje,
      descripcion,
      gasto_ejecutado,
      observaciones
    } = req.body || {};

    if (!obra_id || !fecha || porcentaje === undefined || !descripcion) {
      return res.status(400).json({
        error: 'Obra, fecha, porcentaje y descripción son obligatorios'
      });
    }

    if (porcentaje < 0 || porcentaje > 100) {
      return res.status(400).json({
        error: 'El porcentaje debe estar entre 0 y 100'
      });
    }

    const [result] = await db.query(
      `UPDATE avances 
       SET obra_id = ?, fecha = ?, porcentaje = ?, descripcion = ?, gasto_ejecutado = ?, observaciones = ?
       WHERE id = ?`,
      [
        obra_id,
        fecha,
        porcentaje,
        descripcion,
        gasto_ejecutado || 0,
        observaciones || '',
        req.params.id
      ]
    );

    if (!result.affectedRows) {
      return res.status(404).json({ error: 'Avance no encontrado' });
    }

    res.json({ message: 'Avance actualizado' });
  } catch (error) {
    res.status(500).json({ error: 'Error actualizando avance' });
  }
};

exports.remove = async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM avances WHERE id = ?',
      [req.params.id]
    );

    if (!result.affectedRows) {
      return res.status(404).json({ error: 'Avance no encontrado' });
    }

    res.json({ message: 'Avance eliminado' });
  } catch (error) {
    res.status(500).json({ error: 'Error eliminando avance' });
  }
};