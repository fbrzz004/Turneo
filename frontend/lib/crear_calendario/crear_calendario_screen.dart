import 'package:flutter/material.dart';
import '../models/calendario.dart';
import '../models/empleado.dart';
import '../services/calendario_service.dart';
import '../services/empleado_service.dart';
import 'paso_1.dart';
import 'paso_2.dart';
import 'paso_3.dart';
// import 'paso_4.dart'; // Todavía no lo creamos

class CrearCalendarioScreen extends StatefulWidget {
  final Calendario? calendarioExistente; // Si recibimos esto, es modo "Ver Estado"

  const CrearCalendarioScreen({super.key, this.calendarioExistente});

  @override
  _CrearCalendarioScreenState createState() => _CrearCalendarioScreenState();
}

class _CrearCalendarioScreenState extends State<CrearCalendarioScreen> {
  int _currentStep = 0;
  final _calendarioService = CalendarioService();
  final _empleadoService = EmpleadoService();

  // Variables Paso 1 y 2
  final TextEditingController nombreController = TextEditingController();
  List<DateTime> fechasSeleccionadas = [];
  List<Empleado> empleadosSeleccionados = [];
  List<Empleado> todosLosEmpleados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.calendarioExistente != null) {
      // MODO VER: Saltamos directo al Paso 3 (índice 2)
      _currentStep = 2;
      isLoading = false; // No necesitamos cargar empleados para el paso 3
    } else {
      // MODO CREAR: Iniciamos normal
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

  // --- NAVEGACIÓN ---
  Future<void> _siguientePaso() async {
    if (_currentStep == 0) {
      // ... Validaciones Paso 1 ... (igual que antes)
      if (nombreController.text.isEmpty || fechasSeleccionadas.isEmpty) return;
      setState(() => _currentStep++);
    }
    else if (_currentStep == 1) {
      // ... Validaciones Paso 2 y Guardar ...
      if (empleadosSeleccionados.isEmpty) return;

      try {
        final calId = await _calendarioService.crearCalendario(nombreController.text);
        await _calendarioService.agregarDias(calId, fechasSeleccionadas);
        await _calendarioService.agregarParticipantes(calId, empleadosSeleccionados);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Encuesta enviada")));
        Navigator.pop(context); // Salimos a la lista principal
      } catch (e) {
        // Error handling
      }
    }
  }

  void _irAPaso4() {
    // Lógica para ir al algoritmo (lo veremos luego)
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Yendo al algoritmo... (Próximamente)")));
    // setState(() => _currentStep++);
  }

  @override
  Widget build(BuildContext context) {
    // Si estamos en modo ver existente, usamos ese objeto. Si estamos creando, no hay objeto todavía.
    final calendarioParaPaso3 = widget.calendarioExistente ??
        Calendario(nombre: "Preview", fechaCreacion: DateTime.now(), estado: 0);
    // ^ Placeholder por si llegara a fallar la lógica, pero en flujo normal al llegar a paso 3 ya se guardó y salió.

    final List<Widget> _steps = [
      Paso1(
        nombreController: nombreController,
        fechasSeleccionadas: fechasSeleccionadas,
        onFechasChanged: (f) => setState(() => fechasSeleccionadas = f),
      ),
      Paso2(
        todosLosEmpleados: todosLosEmpleados,
        empleadosSeleccionados: empleadosSeleccionados,
        onSelectionChanged: (s) => setState(() => empleadosSeleccionados = s),
      ),
      // PASO 3: MONITOREO
      Paso3(
        calendario: calendarioParaPaso3,
        onGenerarPresionado: _irAPaso4,
      ),
      // Paso4(), // Futuro
    ];

    // Si estamos viendo un calendario existente, no mostramos el Stepper de arriba ni botones de "Siguiente"
    // porque la pantalla Paso3 ya tiene sus propios botones.
    if (widget.calendarioExistente != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.calendarioExistente!.nombre)),
        body: _steps[2], // Mostramos directamente el Paso 3
      );
    }

    // MODO CREACIÓN (Wizard normal)
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Calendario')),
      body: Column(
        children: [
          // Indicadores (Solo mostramos 1 y 2 para creación)
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
    final isCurrent = _currentStep == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('${index + 1}',
                style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
            fontSize: 12,
            color: isCurrent ? colorScheme.primary : Colors.grey,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal
        ))
      ],
    );
  }
}