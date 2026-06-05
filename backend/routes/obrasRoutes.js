const express = require('express');
const router = express.Router();
const c = require('../controllers/obrasController');

/**
 * @swagger
 * tags:
 *   name: Obras
 *   description: Gestión de obras municipales
 */

/**
 * @swagger
 * /api/obras:
 *   get:
 *     summary: Obtener todas las obras
 *     tags: [Obras]
 */
router.get('/', c.getAll);

/**
 * @swagger
 * /api/obras/reporte:
 *   get:
 *     summary: Reporte general de obras
 *     tags: [Obras]
 */
router.get('/reporte', c.reporte);

/**
 * @swagger
 * /api/obras/estado/{estado}:
 *   get:
 *     summary: Filtrar obras por estado
 *     tags: [Obras]
 *     parameters:
 *       - in: path
 *         name: estado
 *         required: true
 *         schema:
 *           type: string
 */
router.get('/estado/:estado', c.getByEstado);

/**
 * @swagger
 * /api/obras/{id}:
 *   get:
 *     summary: Obtener obra por ID
 *     tags: [Obras]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 */
router.get('/:id', c.getById);

/**
 * @swagger
 * /api/obras:
 *   post:
 *     summary: Crear obra
 *     tags: [Obras]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           example:
 *             nombre: "Construcción de puente municipal"
 *             tipo: "Puente"
 *             ubicacion: "Cuenca"
 *             presupuesto: 250000
 *             estado: "en_ejecucion"
 *             fecha_inicio: "2026-06-01"
 *             fecha_fin: "2026-12-31"
 *             contratista_id: 1
 *             supervisor_id: 1
 */
router.post('/', c.create);

/**
 * @swagger
 * /api/obras/{id}:
 *   put:
 *     summary: Actualizar obra
 *     tags: [Obras]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           example:
 *             nombre: "Construcción de puente municipal actualizado"
 *             tipo: "Puente"
 *             ubicacion: "Cuenca"
 *             presupuesto: 260000
 *             estado: "en_ejecucion"
 *             fecha_inicio: "2026-06-01"
 *             fecha_fin: "2026-12-31"
 *             contratista_id: 1
 *             supervisor_id: 1
 */
router.put('/:id', c.update);

/**
 * @swagger
 * /api/obras/{id}:
 *   delete:
 *     summary: Eliminar obra
 *     tags: [Obras]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 */
router.delete('/:id', c.remove);

module.exports = router;