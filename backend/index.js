require('dotenv').config();

// Dependencias
const express = require('express');

// Obtener variables de entorno (usa el || para un valor por defecto)
const PORT = process.env.PORT || 8080;
const DATABASE_URL = process.env.DATABASE_URL;
const API_KEY = process.env.API_KEY_SECRETA; // Accediendo a la variable del .env

// Inicializar Express
const app = express();

app.get('/', (req, res) => {
    // Nota: Nunca envíes claves secretas directamente al usuario.
    // Esto es solo para demostrar que la variable se ha cargado.
    res.send(`
        <h1>App de Node.js en funcionamiento</h1>
        <p>Servidor corriendo en el puerto: <strong>${PORT}</strong></p>
        <p>URL de la Base de Datos: <strong>${DATABASE_URL}</strong></p>
        <p>Estado de la Clave Secreta: <strong>${API_KEY ? 'Cargada' : 'Fallo al Cargar'}</strong></p>
    `);
});

app.listen(PORT, () => {
    console.log(`🚀 Servidor escuchando en http://localhost:${PORT}`);
    console.log('¡El archivo .env está siendo ignorado correctamente por Git!');
});