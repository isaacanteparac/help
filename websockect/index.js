const express = require('express');
const morgan = require("morgan")
const http = require('http');
const socketIo = require('socket.io');
const PORT = 3000;
const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(morgan("dev"))

// Servir el archivo estático HTML
app.use(express.static('public'));

// Manejar conexiones WebSocket
io.on('connection', (socket) => {
    console.log('New WebSocket connection');

    // Escuchar mensajes enviados desde el cliente
    socket.on('chat message', (msg) => {
        console.log('Message received: ' + msg);
        // Emitir el mensaje a todos los clientes conectados
        io.emit('chat message', msg);
    });

    socket.on('disconnect', () => {
        console.log('User disconnected');
    });
});


server.listen(PORT, () => {
    console.log(`Server is listening on port ${PORT}`);
});
