const express = require('express');
const router = express.Router();
const c = require('../controllers/contratistasController');

/**
 * @swagger
 * tags:
 *   name: Contratistas
 *   description: Gestión de contratistas
 */

/**
 * @swagger
 * /api/contratistas:
 *   get:
 *     summary: Obtener todos los contratistas
 *     tags: [Contratistas]
 */
router.get('/', c.getAll);

/**
 * @swagger
 * /api/contratistas/{id}:
 *   get:
 *     summary: Obtener contratista por ID
 *     tags: [Contratistas]
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
 * /api/contratistas:
 *   post:
 *     summary: Crear contratista
 *     tags: [Contratistas]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           example:
 *             nombre: "Constructora Andes S.A."
 *             ruc: "0198765432001"
 *             telefono: "0991234567"
 *             correo: "andes@email.com"
 *             direccion: "Cuenca"
 */
router.post('/', c.create);

/**
 * @swagger
 * /api/contratistas/{id}:
 *   put:
 *     summary: Actualizar contratista
 *     tags: [Contratistas]
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
 *             nombre: "Constructora Andes Actualizada"
 *             ruc: "0198765432001"
 *             telefono: "0999999999"
 *             correo: "nuevo@email.com"
 *             direccion: "Cuenca"
 */
router.put('/:id', c.update);

/**
 * @swagger
 * /api/contratistas/{id}:
 *   delete:
 *     summary: Eliminar contratista
 *     tags: [Contratistas]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 */
router.delete('/:id', c.remove);

module.exports = router;