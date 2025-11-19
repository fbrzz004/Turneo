import 'package:flutter/material.dart';
import '../models/calendario.dart';
import '../models/empleado.dart';
import '../services/calendario_service.dart';
import '../services/empleado_service.dart';
import 'paso_1.dart';
import 'paso_2.dart';
import 'paso_3.dart';
import 'paso_4.dart'; // <--- 1. IMPORTANTE: Importar el Paso 4

class CrearCalendarioScreen extends StatefulWidget {
  final Calendario? calendarioExistente;

  const CrearCalendarioScreen({super.key, this.calendarioExistente});

  @override
  _CrearCalendarioScreenState createState() => _CrearCalendarioScreenState();
}

class _CrearCalendarioScreenState extends State<CrearCalendarioScreen> {
  int _currentStep = 0;
  final _calendarioService = CalendarioService();
  final _empleadoService = EmpleadoService();

  final TextEditingController nombreController = TextEditingController();
  List<DateTime> fechasSeleccionadas = [];
  List<Empleado> empleadosSeleccionados = [];
  List<Empleado> todosLosEmpleados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.calendarioExistente != null) {
      // MODO VER: Iniciamos en el índice 2 (que corresponde a Paso 3)
      _currentStep = 2;
      isLoading = false;
    } else {
      _cargarDatosIniciales();
    }
  }

  Future<void> _cargarDatosIniciales() async {
    final empleados = await _empleadoService.listarEmpleados();
    setState(() {
      todosLosEmpleados = empleados;
      isLoading = false;
    });
  }

  Future<void> _siguientePaso() async {
    if (_currentStep == 0) {
      if (nombreController.text.isEmpty || fechasSeleccionadas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Completa los datos")));
        return;
      }
      setState(() => _currentStep++);
    }
    else if (_currentStep == 1) {
      if (empleadosSeleccionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecciona empleados")));
        return;
      }
      try {
        final calId = await _calendarioService.crearCalendario(nombreController.text);
        await _calendarioService.agregarDias(calId, fechasSeleccionadas);
        await _calendarioService.agregarParticipantes(calId, empleadosSeleccionados);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Encuesta enviada")));
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }

  // --- 2. LÓGICA CORREGIDA PARA IR AL ALGORITMO ---
  void _irAPaso4() {
    setState(() {
      _currentStep = 3; // Avanzamos al índice 3 (Paso 4)
    });
  }

  @override
  Widget build(BuildContext context) {
    // Objeto seguro para usar en pasos 3 y 4
    final calendarioActual = widget.calendarioExistente ??
        Calendario(nombre: "Preview", fechaCreacion: DateTime.now(), estado: 0);

    final List<Widget> _steps = [
      // Índice 0
      Paso1(
        nombreController: nombreController,
        fechasSeleccionadas: fechasSeleccionadas,
        onFechasChanged: (f) => setState(() => fechasSeleccionadas = f),
      ),
      // Índice 1
      Paso2(
        todosLosEmpleados: todosLosEmpleados,
        empleadosSeleccionados: empleadosSeleccionados,
        onSelectionChanged: (s) => setState(() => empleadosSeleccionados = s),
      ),
      // Índice 2 (Paso 3)
      Paso3(
        calendario: calendarioActual,
        onGenerarPresionado: _irAPaso4, // Conectamos la función
      ),
      // Índice 3 (Paso 4)
      Paso4(
        calendario: calendarioActual,
      ),
    ];

    // --- CASO: MODO VER / MONITOREAR (Entrando desde Mis Calendarios) ---
    if (widget.calendarioExistente != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.calendarioExistente!.nombre)),
        // 3. CORRECCIÓN CRÍTICA: Usamos _currentStep en lugar de dejarlo fijo en [2]
        body: _steps[_currentStep],
      );
    }

    // --- CASO: MODO CREAR (Wizard paso 1 y 2) ---
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Calendario')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(0, "Config"),
                const SizedBox(width: 20),
                _buildStepIndicator(1, "Personal"),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _steps[_currentStep],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  child: const Text('Atrás'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _siguientePaso,
                child: Text(_currentStep == 1 ? 'Enviar Encuesta' : 'Siguiente'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int index, String label) {
    final isActive = _currentStep >= index;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(children: [
      Icon(isActive ? Icons.check_circle : Icons.circle_outlined, color: isActive ? colorScheme.primary : Colors.grey),
      Text(label)
    ]);
  }
}