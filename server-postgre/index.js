const express = require('express');
const morgan = require('morgan');
const cors = require('cors'); 
const app = express();
const port = 3030;

const crudRouter = require("./src/crudRouter")

// Usar CORS para permitir solicitudes de cualquier origen
app.use(cors());

// Usar Morgan para el registro de solicitudes
app.use(morgan('dev'));

// Usar BodyParser para manejar solicitudes JSON con un límite de tamaño
app.use(express.json({ limit: '15mb' }));
//
app.use("/api",crudRouter)


app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}/api`);
});