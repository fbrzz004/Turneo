/**************************************************************
 *  ALGORITMO GREEDY PARA ASIGNACIÓN DE TURNOS
 *  Basado en el modelo de datos v3
 *************************************************************/

// Utilitario: calcular horas entre turnos (para restricciones)
function calcularHoras(hora_inicio, hora_fin, cruza_dia) {
  const [h1, m1] = hora_inicio.split(":").map(Number);
  const [h2, m2] = hora_fin.split(":").map(Number);

  let inicio = h1 * 60 + m1;
  let fin = h2 * 60 + m2;

  if (cruza_dia && fin < inicio) {
    fin += 24 * 60;
  }

  return (fin - inicio) / 60;
}

// ------------------------------------------------------------
// ALGORTIMO GREEDY
// ------------------------------------------------------------
export function asignarTurnosGreedy({
  semana,
  demanda,
  habilitados,
  disponibilidad,
  empleados,
  turnos,
  restricciones,
}) {
  console.log("===== INICIO ALGORITMO GREEDY =====");

  const resultado = [];
  const faltantes = [];

  // Estructura para tracking
  const cargaHoras = {}; // horas totales por empleado
  const turnosDia = {}; // turnos tomados en un día por empleado
  const ultimaAsignacion = {}; // última asignación para validación de descanso

  empleados.forEach((e) => {
    cargaHoras[e.id] = 0;
    turnosDia[e.id] = {};
    ultimaAsignacion[e.id] = null;
  });

  // ------------------------------------------------------------
  // 1. Construir todos los slots
  // ------------------------------------------------------------
  const slots = [];

  for (const d of demanda) {
    if (d.id_semana !== semana.id_semana) continue;

    for (const rolReq of d.personal) {
      for (let i = 0; i < rolReq.cantidad; i++) {
        slots.push({
          id_dia: d.id_dia,
          id_turno: d.id_turno,
          id_rol: rolReq.id_rol,
          slot_id: `${d.id_dia}-${d.id_turno}-${rolReq.id_rol}-${i + 1}`,
        });
      }
    }
  }

  console.log("Total slots generados:", slots.length);

  // ------------------------------------------------------------
  // 2. Ordenar slots por "dificultad"
  // ------------------------------------------------------------
  slots.sort((a, b) => {
    const ta = turnos.find((t) => t.id === a.id_turno);
    const tb = turnos.find((t) => t.id === b.id_turno);

    // Turnos nocturnos primero
    if (tb.cruza_dia && !ta.cruza_dia) return 1;
    if (ta.cruza_dia && !tb.cruza_dia) return -1;

    // Roles con menor cantidad disponible deben ir primero (hecho más adelante)
    return 0;
  });

  // ------------------------------------------------------------
  // 3. Asignar cada slot usando estrategia Greedy
  // ------------------------------------------------------------
  for (const slot of slots) {
    const { id_dia, id_turno, id_rol, slot_id } = slot;

    console.log(`\n--- Procesando SLOT ${slot_id} (rol ${id_rol}) ---`);

    // Obtener empleados habilitados ese día
    const hab = habilitados.find(
      (h) => h.id_semana === semana.id_semana && h.id_dia === id_dia
    );

    if (!hab) {
      console.log("No hay empleados habilitados este día");
      faltantes.push({ slot, motivo: "Día sin habilitados" });
      continue;
    }

    const habilitadosDia = hab.empleados;

    // Obtener empleados con disponibilidad ese día/turno
    const disponiblesTurno = disponibilidad
      .filter((d) => d.id_semana === semana.id_semana)
      .filter((d) =>
        d.dias.some(
          (day) => day.id_dia === id_dia && day.turnos.includes(id_turno)
        )
      )
      .map((d) => d.id_empleado);

    console.log("Habilitados:", habilitadosDia);
    console.log("Disponibles turno:", disponiblesTurno);

    // Filtrar empleados válidos
    let candidatos = empleados.filter(
      (e) =>
        e.id_rol === id_rol &&
        habilitadosDia.includes(e.id) &&
        disponiblesTurno.includes(e.id)
    );

    console.log(
      "Candidatos por rol:",
      candidatos.map((c) => c.nombre)
    );

    // Aplicar restricciones
    candidatos = candidatos.filter((e) => {
      const asignacionesDia = turnosDia[e.id][id_dia] || 0;
      if (asignacionesDia >= restricciones.max_turnos_por_dia) {
        console.log(`Restricción: ${e.nombre} excede max_turnos_por_dia`);
        return false;
      }

      // Validación descanso entre turnos
      const turnoActual = turnos.find((t) => t.id === id_turno);
      const ultimo = ultimaAsignacion[e.id];

      if (ultimo) {
        const horasDescanso = Math.abs(
          ultimo.fin_abs - turnoActual.hora_inicio_abs
        );
        if (horasDescanso < restricciones.min_descanso_horas) {
          console.log(`Restricción: ${e.nombre} no cumple descanso mínimo`);
          return false;
        }
      }

      return true;
    });

    if (candidatos.length === 0) {
      console.log("❌ No hay candidatos disponibles para este slot.");
      faltantes.push({
        slot_id: slot.slot_id,
        motivo: "No hay personal disponible",
      });
      continue;
    }

    // Orden greedy: menos carga horaria → menos turnos ese día
    candidatos.sort((a, b) => {
      const cargaA = cargaHoras[a.id];
      const cargaB = cargaHoras[b.id];

      if (cargaA !== cargaB) return cargaA - cargaB;

      const turnosA = turnosDia[a.id][id_dia] || 0;
      const turnosB = turnosDia[b.id][id_dia] || 0;
      return turnosA - turnosB;
    });

    const elegido = candidatos[0];
    console.log(`✔ Asignado: ${elegido.nombre}`);

    // Guardar asignación
    resultado.push({
      id_empleado: elegido.id,
      id_dia,
      id_turno,
    });

    // Actualizar estado
    const turno = turnos.find((t) => t.id === id_turno);
    const horas = calcularHoras(
      turno.hora_inicio,
      turno.hora_fin,
      turno.cruza_dia
    );

    cargaHoras[elegido.id] += horas;
    turnosDia[elegido.id][id_dia] = (turnosDia[elegido.id][id_dia] || 0) + 1;

    // Guardar última asignación (absolutizando horas)
    ultimaAsignacion[elegido.id] = {
      dia: id_dia,
      turno: id_turno,
      fin_abs: turno.cruza_dia
        ? 24 + Number(turno.hora_fin.split(":")[0])
        : Number(turno.hora_fin.split(":")[0]),
    };
  }

  console.log("===== FIN ALGORITMO GREEDY =====");

  return { resultado, faltantes };
}
