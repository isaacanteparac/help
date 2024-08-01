const express = require("express");
const router = express.Router();

const controller = require("./crudController");

// Rutas para usuarios
router.route('/')
  .post(controller.createUser)  // Ruta para crear un usuario
  .get(controller.readUsers);   // Ruta para leer todos los usuarios

// Ruta para operaciones con un usuario específico
router.route('/:id')
  .get(controller.readUserId)   // Ruta para leer un usuario específico
  .put(controller.updateUserId) // Ruta para actualizar un usuario específico
  .delete(controller.deleteUserId); // Ruta para eliminar un usuario específico



// Rutas para posts
router.route('/post')
  .post(controller.createPost)
  .get(controller.readPost)    // Ruta para leer todos los posts

// Ruta para leer posts de un usuario específico
router.route('/posts/user/:id')
  .get(controller.readPostsByUserId);  // Ruta para leer posts de un usuario específico

module.exports = router;
