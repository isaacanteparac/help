const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

const crud = {}

// Crear un nuevo usuario
crud.createUser = async (req, res) => {
    try {
        console.log('Received data:', req.body); // Verifica el cuerpo de la solicitud

        const { email, name } = req.body;
        if (!email || !name) {
            return res.status(400).json({ error: 'Email and name are required' });
        }

        const user = await prisma.user.create({
            data: { email, name }
        });

        res.status(201).json({ result: user });
    } catch (error) {
        console.error('Error creating user:', error);
        res.status(500).json({ error: 'Failed to create user', details: error.message });
    }
};


// Leer todos los usuarios
crud.readUsers = async (req, res) => {
    try {
        const allUsers = await prisma.user.findMany()
        res.status(200).json(allUsers )
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch users', details: error.message })
    }
}

// Leer un usuario por ID
crud.readUserId = async (req, res) => {
    const { id } = req.params
    try {
        const userId = parseInt(id, 10) // Convertir a entero
        const user = await prisma.user.findUnique({
            where: { id: userId }
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
        const userId = parseInt(id, 10) // Convertir id a entero
        const updatedUser = await prisma.user.update({
            where: { id: userId },
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
        const userId = parseInt(id, 10) // Convertir el id a entero
        await prisma.user.delete({
            where: { id: userId }
        })
        res.status(204).send() // Sin contenido después de la eliminación
    } catch (error) {
        res.status(500).json({ error: 'Failed to delete user', details: error.message })
    }
}

// Crear un nuevo post para un usuario existente
crud.createPost = async (req, res) => {
    try {
        const { userId, title, content, published } = req.body

        // Verificar que userId no sea undefined
        if (!userId) {
            return res.status(400).json({ error: 'User ID is required' })
        }

        // Buscar el usuario
        const user = await prisma.user.findUnique({
            where: { id: userIdInt }
        })

        if (!user) {
            return res.status(404).json({ error: 'User not found' })
        }

        // Crear el post
        const post = await prisma.post.create({
            data: {
                title,
                content,
                published: published ?? false,
                authorId: userIdInt
            }
        })
        res.status(201).json({ result: post })
    } catch (error) {
        res.status(500).json({ error: 'Failed to create post', details: error.message })
    }
}



// Leer todos los posts
crud.readPost = async (req, res) => {
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
        // Convertir el id a entero
        const userId = parseInt(id, 10)
        
        // Verificar que el id sea un número válido
        if (isNaN(userId)) {
            return res.status(400).json({ error: 'Invalid user ID' })
        }

        // Buscar los posts por authorId
        const posts = await prisma.post.findMany({
            where: {
                authorId: userId // Usar el id convertido directamente
            }
        })

        res.status(200).json({ result: posts })
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch posts for user', details: error.message })
    }
}


module.exports = crud
