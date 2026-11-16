import 'package:flutter/cupertino.dart';
import '../app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});
  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  late final TextEditingController _nombre;
  late final TextEditingController _email;
  late final TextEditingController _telefono;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: SesionActual.nombre);
    _email = TextEditingController(text: SesionActual.email);
    _telefono = TextEditingController(text: SesionActual.telefono);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _telefono.dispose();
    super.dispose();
  }

  void _guardar() {
    final nombre = _nombre.text.trim();
    final email = _email.text.trim();
    final telefono = _telefono.text.trim();
    if (nombre.isEmpty || email.isEmpty || telefono.isEmpty) {
      _mostrarError('Completa todos los campos.');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _mostrarError('Ingresa un correo institucional válido.');
      return;
    }
    SesionActual.nombre = nombre;
    SesionActual.email = email;
    SesionActual.telefono = telefono;
    Navigator.pop(context);
  }

  void _mostrarError(String mensaje) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Revisa los datos'),
        content: Text(mensaje),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Editar Perfil')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 4),
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/perfil_docente.png',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppTheme.card(context), width: 2),
                      ),
                      child: const Icon(CupertinoIcons.camera_fill,
                          color: CupertinoColors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _label('Nombre completo'),
            AppField(
                controller: _nombre,
                placeholder: 'Nombre',
                icon: CupertinoIcons.person),
            const SizedBox(height: 16),
            _label('Correo institucional'),
            AppField(
                controller: _email,
                placeholder: 'Correo',
                icon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _label('Teléfono'),
            AppField(
                controller: _telefono,
                placeholder: 'Teléfono',
                icon: CupertinoIcons.phone,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 26),
            PrimaryButton(text: 'Guardar cambios', onPressed: _guardar),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 4),
        child: Text(t,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: CupertinoColors.systemGrey)),
      );
}
