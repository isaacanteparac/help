const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

const crud = {}

// Crear un nuevo usuario
crud.createUser = async (req, res) => {
    try {
        const { email, name } = req.body
        const user = await prisma.user.create({
            data: {
                email,
                name
            }
        })
        res.status(201).json({ result: user })
    } catch (error) {
        res.status(500).json({ error: 'Failed to create user', details: error.message })
    }
}

// Crear un nuevo post para un usuario existente
crud.createPost = async (req, res) => {
    try {
        const { userId, title, content, published } = req.body
        const user = await prisma.user.findUnique({
            where: { id: userId }
        })
        
        if (!user) {
            return res.status(404).json({ error: 'User not found' })
        }

        const post = await prisma.post.create({
            data: {
                title,
                content,
                published: published ?? false,
                authorId: userId
            }
        })
        res.status(201).json({ result: post })
    } catch (error) {
        res.status(500).json({ error: 'Failed to create post', details: error.message })
    }
}

// Leer todos los usuarios
crud.readUsers = async (req, res) => {
    try {
        const allUsers = await prisma.user.findMany()
        res.status(200).json({ result: allUsers })
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch users', details: error.message })
    }
}

// Leer un usuario por ID
crud.readUserId = async (req, res) => {
    const { id } = req.params
    try {
        const user = await prisma.user.findUnique({
            where: { id: id }
        })
        if (user) {
            res.status(200).json({ result: user })
        } else {
            res.status(404).json({ error: 'User not found' })
        }
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch user', details: error.message })
    }
}

// Actualizar un usuario por ID
crud.updateUserId = async (req, res) => {
    const { id } = req.params
    try {
        const updatedUser = await prisma.user.update({
            where: { id: id },
            data: req.body
        })
        res.status(200).json({ result: updatedUser })
    } catch (error) {
        res.status(500).json({ error: 'Failed to update user', details: error.message })
    }
}

// Eliminar un usuario por ID
crud.deleteUserId = async (req, res) => {
    const { id } = req.params
    try {
        await prisma.user.delete({
            where: { id: id }
        })
        res.status(204).send()
    } catch (error) {
        res.status(500).json({ error: 'Failed to delete user', details: error.message })
    }
}

// Leer todos los posts
crud.readPosts = async (req, res) => {
    try {
        const allPosts = await prisma.post.findMany()
        res.status(200).json({ result: allPosts })
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch posts', details: error.message })
    }
}

// Leer todos los posts de un usuario específico
crud.readPostsByUserId = async (req, res) => {
    const { id } = req.params
    try {
        const posts = await prisma.post.findMany({
            where: { authorId: id }
        })
        res.status(200).json({ result: posts })
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch posts for user', details: error.message })
    }
}

module.exports = crud
