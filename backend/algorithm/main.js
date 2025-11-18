import {
  semana,
  demanda,
  habilitados,
  disponibilidad,
  empleados,
  turnos,
  restricciones,
} from "../algorithm/input2.js";
import { asignarTurnosGreedy } from "./greedy.js";

// Ejecucion del algoritmo greedy
const response = asignarTurnosGreedy({
  semana,
  demanda,
  habilitados,
  disponibilidad,
  empleados,
  turnos,
  restricciones,
});

console.log("===== RESULTADO FINAL =====");
console.log(response);
