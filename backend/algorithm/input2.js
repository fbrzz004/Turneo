// ------------------------------------------------------------
// DATASET 3 – FULL WEEK
// ------------------------------------------------------------

export const dias = [
  { id: 1, nombre: "Lunes" },
  { id: 2, nombre: "Martes" },
  { id: 3, nombre: "Miércoles" },
  { id: 4, nombre: "Jueves" },
  { id: 5, nombre: "Viernes" },
  { id: 6, nombre: "Sábado" },
  { id: 7, nombre: "Domingo" },
];

export const roles = [
  { id: 1, nombre: "Mesero" },
  { id: 2, nombre: "Cocinero" },
  { id: 3, nombre: "Barra" },
];

export const turnos = [
  {
    id: 1,
    nombre: "Mañana",
    hora_inicio: "07:00",
    hora_fin: "15:00",
    cruza_dia: false,
  },
  {
    id: 2,
    nombre: "Tarde",
    hora_inicio: "15:00",
    hora_fin: "23:00",
    cruza_dia: false,
  },
  {
    id: 3,
    nombre: "Noche",
    hora_inicio: "23:00",
    hora_fin: "07:00",
    cruza_dia: true,
  },
];

export const semana = {
  id_semana: 202548,
  dias_activos: [1, 2, 3, 4, 5, 6, 7],
};

// ---------------- DEMANDA REALISTA ---------------------
export const demanda = [];
for (let d = 1; d <= 7; d++) {
  demanda.push(
    {
      id_semana: 202548,
      id_dia: d,
      id_turno: 1,
      personal: [
        { id_rol: 1, cantidad: 2 },
        { id_rol: 2, cantidad: 1 },
      ],
    },
    {
      id_semana: 202548,
      id_dia: d,
      id_turno: 2,
      personal: [
        { id_rol: 1, cantidad: 2 },
        { id_rol: 3, cantidad: 1 },
      ],
    },
    {
      id_semana: 202548,
      id_dia: d,
      id_turno: 3,
      personal: [
        { id_rol: 1, cantidad: 1 },
        { id_rol: 2, cantidad: 1 },
      ],
    }
  );
}

// ---------------- EMPLEADOS -----------------------
export const empleados = [
  { id: 1, nombre: "Juan", id_rol: 1 },
  { id: 2, nombre: "Ana", id_rol: 1 },
  { id: 3, nombre: "Luis", id_rol: 2 },
  { id: 4, nombre: "María", id_rol: 3 },
  { id: 5, nombre: "Pedro", id_rol: 1 },
  { id: 6, nombre: "Carla", id_rol: 1 },
  { id: 7, nombre: "Bruno", id_rol: 2 },
  { id: 8, nombre: "Sofía", id_rol: 3 },
  { id: 9, nombre: "Lucas", id_rol: 1 },
  { id: 10, nombre: "Nina", id_rol: 1 },
  { id: 11, nombre: "Diego", id_rol: 2 },
];

// Todos habilitados los 7 días
export const habilitados = dias.map((d) => ({
  id_semana: 202548,
  id_dia: d.id,
  empleados: empleados.map((e) => e.id),
}));

// -------------------- DISPONIBILIDAD -------------------
export const disponibilidad = empleados.map((e) => ({
  id_empleado: e.id,
  id_semana: 202548,
  dias: dias.map((dd) => ({
    id_dia: dd.id,
    turnos:
      e.id % 3 === 0
        ? [1] // cocineros: mañana únicamente
        : e.id % 3 === 1
        ? [1, 2] // meseros: mañana + tarde
        : [2, 3], // barra: tarde + noche
  })),
}));

// -------------------- RESTRICCIONES ---------------------
export const restricciones = {
  max_turnos_por_dia: 1,
  min_descanso_horas: 8,
  max_horas_semanales: 48,
  min_horas_semanales: 10,
};
