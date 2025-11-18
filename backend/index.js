import express from "express";
import { testConnection } from "./config/db.js";

const app = express();
app.use(express.json());

testConnection();

app.get("/", (req, res) => {
  res.send("Servidor funcionando");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Servidor en puerto ${PORT}`));
