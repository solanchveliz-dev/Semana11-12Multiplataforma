import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _enviarCodigo() {
    final email = _email.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Correo no válido'),
          content: const Text('Ingresa un correo institucional válido.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pushNamed(context, '/verificar', arguments: email);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Recuperar contraseña'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/recuperar_3d.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 22),
              Text('Recuperar contraseña',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context))),
              const SizedBox(height: 8),
              const Text(
                'Ingresa tu correo y te enviaremos un código de verificación.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
              const SizedBox(height: 24),
              AppField(
                controller: _email,
                placeholder: 'Correo institucional',
                icon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                text: 'Enviar código',
                onPressed: _enviarCodigo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
