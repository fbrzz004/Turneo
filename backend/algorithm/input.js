// ------------------------------------------------------------
// DATASET 1 – SIMPLE
// ------------------------------------------------------------

// Catálogos
export const dias = [
  { id: 1, nombre: "Lunes" },
  { id: 2, nombre: "Martes" },
  { id: 3, nombre: "Miércoles" },
];

export const roles = [
  { id: 1, nombre: "Mesero" },
  { id: 2, nombre: "Cocinero" },
];

export const turnos = [
  {
    id: 1,
    nombre: "Mañana",
    hora_inicio: "08:00",
    hora_fin: "14:00",
    cruza_dia: false,
  },
  {
    id: 2,
    nombre: "Tarde",
    hora_inicio: "14:00",
    hora_fin: "20:00",
    cruza_dia: false,
  },
  {
    id: 3,
    nombre: "Noche",
    hora_inicio: "20:00",
    hora_fin: "02:00",
    cruza_dia: true,
  },
];

// Semana activa
export const semana = {
  id_semana: 202546,
  dias_activos: [1, 2, 3],
};

// -------------- DEMANDA (toda cubrible) ---------------------
export const demanda = [
  {
    id_semana: 202546,
    id_dia: 1,
    id_turno: 1,
    personal: [
      { id_rol: 1, cantidad: 2 },
      { id_rol: 2, cantidad: 1 },
    ],
  },
  {
    id_semana: 202546,
    id_dia: 1,
    id_turno: 2,
    personal: [{ id_rol: 1, cantidad: 1 }],
  },

  {
    id_semana: 202546,
    id_dia: 2,
    id_turno: 1,
    personal: [
      { id_rol: 1, cantidad: 1 },
      { id_rol: 2, cantidad: 1 },
    ],
  },
  {
    id_semana: 202546,
    id_dia: 2,
    id_turno: 3,
    personal: [{ id_rol: 1, cantidad: 1 }],
  },

  {
    id_semana: 202546,
    id_dia: 3,
    id_turno: 1,
    personal: [{ id_rol: 2, cantidad: 1 }],
  },
];

// -------------- EMPLEADOS ---------------------
export const empleados = [
  { id: 1, nombre: "Juan", id_rol: 1 },
  { id: 2, nombre: "Ana", id_rol: 1 },
  { id: 3, nombre: "Luis", id_rol: 2 },
  { id: 4, nombre: "Laura", id_rol: 1 },
  { id: 5, nombre: "Mario", id_rol: 2 },
];

// -------------- HABILITADOS POR DÍA -----------------
export const habilitados = [
  { id_semana: 202546, id_dia: 1, empleados: [1, 2, 3, 4, 5] },
  { id_semana: 202546, id_dia: 2, empleados: [1, 2, 3, 4] },
  { id_semana: 202546, id_dia: 3, empleados: [2, 3, 5] },
];

// -------------- DISPONIBILIDAD ----------------------
export const disponibilidad = [
  {
    id_empleado: 1,
    id_semana: 202546,
    dias: [
      { id_dia: 1, turnos: [1, 2] },
      { id_dia: 2, turnos: [1] },
    ],
  },
  {
    id_empleado: 2,
    id_semana: 202546,
    dias: [
      { id_dia: 1, turnos: [1] },
      { id_dia: 2, turnos: [1, 3] },
      { id_dia: 3, turnos: [1, 3] },
    ],
  },
  {
    id_empleado: 3,
    id_semana: 202546,
    dias: [
      { id_dia: 1, turnos: [1, 2] },
      { id_dia: 2, turnos: [1, 2] },
      { id_dia: 3, turnos: [1] },
    ],
  },
  {
    id_empleado: 4,
    id_semana: 202546,
    dias: [
      { id_dia: 1, turnos: [2] },
      { id_dia: 2, turnos: [1] },
    ],
  },
  {
    id_empleado: 5,
    id_semana: 202546,
    dias: [
      { id_dia: 1, turnos: [3] },
      { id_dia: 3, turnos: [1] },
    ],
  },
];

// -------------- RESTRICCIONES -------------------
export const restricciones = {
  max_turnos_por_dia: 1,
  min_descanso_horas: 8,
  max_horas_semanales: 40,
  min_horas_semanales: 10,
};
