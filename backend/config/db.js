import dotenv from "dotenv";
import pkg from "pg";

dotenv.config();

const { Pool } = pkg;

// Crear pool de conexión
export const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: {
    rejectUnauthorized: false
  }
});

export const testConnection = async () => {
  try {
    const res = await pool.query("SELECT NOW()");
    console.log("📌 PostgreSQL conectado correctamente:", res.rows[0].now);
  } catch (error) {
    console.error("❌ Error conectando a PostgreSQL:", error.message);
  }
};
