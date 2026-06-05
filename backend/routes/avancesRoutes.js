const express = require('express');
const router = express.Router();
const c = require('../controllers/avancesController');

/**
 * @swagger
 * tags:
 *   name: Avances
 *   description: Gestión del avance de las obras
 */

/**
 * @swagger
 * /api/avances:
 *   get:
 *     summary: Obtener todos los avances
 *     tags: [Avances]
 */
router.get('/', c.getAll);

/**
 * @swagger
 * /api/avances/obra/{obra_id}:
 *   get:
 *     summary: Obtener avances por obra
 *     tags: [Avances]
 *     parameters:
 *       - in: path
 *         name: obra_id
 *         required: true
 *         schema:
 *           type: integer
 */
router.get('/obra/:obra_id', c.getByObra);

/**
 * @swagger
 * /api/avances/{id}:
 *   get:
 *     summary: Obtener avance por ID
 *     tags: [Avances]
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
 * /api/avances:
 *   post:
 *     summary: Registrar avance
 *     tags: [Avances]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           example:
 *             obra_id: 1
 *             fecha: "2026-06-05"
 *             porcentaje: 25
 *             descripcion: "Inicio de trabajos y preparación del terreno"
 *             gasto_ejecutado: 50000
 *             observaciones: "Avance dentro del cronograma"
 */
router.post('/', c.create);

/**
 * @swagger
 * /api/avances/{id}:
 *   put:
 *     summary: Actualizar avance
 *     tags: [Avances]
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
 *             obra_id: 1
 *             fecha: "2026-06-10"
 *             porcentaje: 40
 *             descripcion: "Avance de estructura principal"
 *             gasto_ejecutado: 80000
 *             observaciones: "Trabajo sin novedades"
 */
router.put('/:id', c.update);

/**
 * @swagger
 * /api/avances/{id}:
 *   delete:
 *     summary: Eliminar avance
 *     tags: [Avances]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 */
router.delete('/:id', c.remove);

module.exports = router;