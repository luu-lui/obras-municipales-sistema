const express = require('express');
const router = express.Router();
const c = require('../controllers/supervisoresController');

/**
 * @swagger
 * tags:
 *   name: Supervisores
 *   description: Gestión de supervisores
 */

/**
 * @swagger
 * /api/supervisores:
 *   get:
 *     summary: Obtener todos los supervisores
 *     tags: [Supervisores]
 */
router.get('/', c.getAll);

/**
 * @swagger
 * /api/supervisores/{id}:
 *   get:
 *     summary: Obtener supervisor por ID
 *     tags: [Supervisores]
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
 * /api/supervisores:
 *   post:
 *     summary: Crear supervisor
 *     tags: [Supervisores]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           example:
 *             nombre: "Ing. Carlos Méndez"
 *             cargo: "Supervisor de infraestructura"
 *             telefono: "0971112222"
 *             correo: "carlos@municipio.gob.ec"
 */
router.post('/', c.create);

/**
 * @swagger
 * /api/supervisores/{id}:
 *   put:
 *     summary: Actualizar supervisor
 *     tags: [Supervisores]
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
 *             nombre: "Ing. Carlos Méndez"
 *             cargo: "Supervisor general"
 *             telefono: "0971112222"
 *             correo: "carlos@municipio.gob.ec"
 */
router.put('/:id', c.update);

/**
 * @swagger
 * /api/supervisores/{id}:
 *   delete:
 *     summary: Eliminar supervisor
 *     tags: [Supervisores]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 */
router.delete('/:id', c.remove);

module.exports = router;