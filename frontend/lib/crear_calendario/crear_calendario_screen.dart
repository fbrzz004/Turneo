import 'package:flutter/material.dart';
import 'paso_1.dart';
import 'paso_2.dart';
import 'paso_3.dart';
import 'paso_4.dart';

class CrearCalendarioScreen extends StatefulWidget {
  const CrearCalendarioScreen({super.key});

  @override
  _CrearCalendarioScreenState createState() => _CrearCalendarioScreenState();
}

class _CrearCalendarioScreenState extends State<CrearCalendarioScreen> {
  int _currentStep = 0;

  final List<Widget> _steps = [
    const Paso1(),
    const Paso2(),
    const Paso3(),
    const Paso4(),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Calendario'),
      ),
      body: IndexedStack(
        index: _currentStep,
        children: _steps,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (index) => _buildStepIndicator(index),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _currentStep == _steps.length - 1 ? () {} : _nextStep,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_currentStep == _steps.length - 1 ? 'Aceptar' : 'Siguiente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _currentStep == index ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: _currentStep == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}