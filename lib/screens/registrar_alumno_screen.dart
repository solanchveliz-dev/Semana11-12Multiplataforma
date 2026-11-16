import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../db/database_helper.dart';
import '../models/alumno.dart';
import '../widgets/app_widgets.dart';

class RegistrarAlumnoScreen extends StatefulWidget {
  final Alumno? alumno;
  const RegistrarAlumnoScreen({super.key, this.alumno});
  @override
  State<RegistrarAlumnoScreen> createState() => _RegistrarAlumnoScreenState();
}

class _RegistrarAlumnoScreenState extends State<RegistrarAlumnoScreen> {
  late final TextEditingController _nombre;
  late final TextEditingController _apellido;
  late final TextEditingController _nota;

  bool get _esEdicion => widget.alumno != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.alumno?.nombre ?? '');
    _apellido = TextEditingController(text: widget.alumno?.apellido ?? '');
    _nota = TextEditingController(
        text: widget.alumno != null
            ? widget.alumno!.nota.toStringAsFixed(0)
            : '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _nota.dispose();
    super.dispose();
  }

  void _error(String msg) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Revisa los datos'),
        content: Text(msg),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _guardar() async {
    final nombre = _nombre.text.trim();
    final apellido = _apellido.text.trim();
    final notaTxt = _nota.text.trim().replaceAll(',', '.');
    if (nombre.isEmpty || apellido.isEmpty || notaTxt.isEmpty) {
      _error('Completa todos los campos.');
      return;
    }
    final nota = double.tryParse(notaTxt);
    if (nota == null || nota < 0 || nota > 20) {
      _error('La nota debe ser un número entre 0 y 20.');
      return;
    }
    if (_esEdicion) {
      await DatabaseHelper.instance.actualizar(widget.alumno!
          .copyWith(nombre: nombre, apellido: apellido, nota: nota));
    } else {
      await DatabaseHelper.instance
          .crear(Alumno(nombre: nombre, apellido: apellido, nota: nota));
    }
    if (mounted) Navigator.pop(context);
  }

  void _ajustarNota(int cambio) {
    final actual = double.tryParse(_nota.text.replaceAll(',', '.')) ?? 0;
    final siguiente = (actual + cambio).clamp(0, 20);
    _nota.text = siguiente.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_esEdicion ? 'Editar Alumno' : 'Registrar Alumno'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 4),
            AppField(
                controller: _nombre,
                placeholder: 'Nombre del alumno',
                icon: CupertinoIcons.person),
            const SizedBox(height: 14),
            AppField(
                controller: _apellido,
                placeholder: 'Apellido',
                icon: CupertinoIcons.person_badge_plus),
            const SizedBox(height: 14),
            _controlNota(),
            const SizedBox(height: 22),
            PrimaryButton(
                text: _esEdicion ? 'Actualizar' : 'Guardar',
                onPressed: _guardar),
            const SizedBox(height: 30),
            if (!_esEdicion)
              Center(
                child: Image.asset(
                  'assets/images/aprendizaje_3d.png',
                  width: 230,
                  height: 170,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _notaBoton(IconData icon, VoidCallback onPressed) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 36),
      onPressed: onPressed,
      child: Icon(icon, size: 20, color: AppTheme.primary),
    );
  }

  Widget _controlNota() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.chart_bar,
              color: CupertinoColors.systemGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Nota (0 - 20)',
                style: TextStyle(color: AppTheme.textColor(context))),
          ),
          _notaBoton(CupertinoIcons.minus, () => _ajustarNota(-1)),
          SizedBox(
            width: 42,
            child: CupertinoTextField(
              controller: _nota,
              textAlign: TextAlign.center,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(),
            ),
          ),
          _notaBoton(CupertinoIcons.plus, () => _ajustarNota(1)),
        ],
      ),
    );
  }
}
