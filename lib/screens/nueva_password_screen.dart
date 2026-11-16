import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class NuevaPasswordScreen extends StatefulWidget {
  const NuevaPasswordScreen({super.key});

  @override
  State<NuevaPasswordScreen> createState() => _NuevaPasswordScreenState();
}

class _NuevaPasswordScreenState extends State<NuevaPasswordScreen> {
  final _password = TextEditingController();
  final _confirmar = TextEditingController();
  bool _mostrarPassword = false;
  bool _mostrarConfirmacion = false;

  bool get _longitudValida => _password.text.length >= 8;
  bool get _mayusculaValida => RegExp(r'[A-Z]').hasMatch(_password.text);
  bool get _numeroValido => RegExp(r'[0-9]').hasMatch(_password.text);

  @override
  void dispose() {
    _password.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _actualizar() => setState(() {});

  void _guardar() {
    if (!_longitudValida || !_mayusculaValida || !_numeroValido) {
      _mostrarError('La contraseña aún no cumple todos los requisitos.');
      return;
    }
    if (_password.text != _confirmar.text) {
      _mostrarError('Las contraseñas no coinciden.');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Nueva contraseña'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/password_3d.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 22),
              Text('Nueva contraseña',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context))),
              const SizedBox(height: 8),
              const Text('Crea una nueva contraseña segura para tu cuenta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CupertinoColors.systemGrey)),
              const SizedBox(height: 24),
              AppField(
                controller: _password,
                placeholder: 'Nueva contraseña',
                icon: CupertinoIcons.lock,
                obscure: !_mostrarPassword,
                onChanged: (_) => _actualizar(),
                suffix: _visibilityButton(
                  _mostrarPassword,
                  () => setState(() => _mostrarPassword = !_mostrarPassword),
                ),
              ),
              const SizedBox(height: 14),
              AppField(
                controller: _confirmar,
                placeholder: 'Confirmar contraseña',
                icon: CupertinoIcons.lock,
                obscure: !_mostrarConfirmacion,
                onChanged: (_) => _actualizar(),
                suffix: _visibilityButton(
                  _mostrarConfirmacion,
                  () => setState(
                      () => _mostrarConfirmacion = !_mostrarConfirmacion),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Requisito(
                        texto: 'Mínimo 8 caracteres', valido: _longitudValida),
                    _Requisito(
                        texto: 'Una letra mayúscula', valido: _mayusculaValida),
                    _Requisito(texto: 'Un número', valido: _numeroValido),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                text: 'Actualizar contraseña',
                onPressed: _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _visibilityButton(bool visible, VoidCallback onPressed) {
    return CupertinoButton(
      padding: const EdgeInsets.only(right: 10),
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Icon(
        visible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
        color: CupertinoColors.systemGrey,
        size: 20,
      ),
    );
  }
}

class _Requisito extends StatelessWidget {
  final String texto;
  final bool valido;
  const _Requisito({required this.texto, required this.valido});

  @override
  Widget build(BuildContext context) {
    final color = valido ? AppTheme.success : CupertinoColors.systemGrey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            valido
                ? CupertinoIcons.checkmark_alt_circle_fill
                : CupertinoIcons.circle,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(texto, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
