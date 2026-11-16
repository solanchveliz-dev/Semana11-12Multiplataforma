import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _ver = false;
  bool _recordar = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (_email.text.trim().isEmpty || _password.text.trim().isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Campos vacíos'),
          content: const Text('Ingresa tu correo y contraseña.'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/login_academico.png',
                  width: 100,
                  height: 90,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text('Iniciar sesión',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor(context))),
                const SizedBox(height: 6),
                const Text('Accede a tu cuenta para continuar',
                    style: TextStyle(color: CupertinoColors.systemGrey)),
                const SizedBox(height: 26),
                AppField(
                  controller: _email,
                  placeholder: 'Correo institucional',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                AppField(
                  controller: _password,
                  placeholder: 'Contraseña',
                  icon: CupertinoIcons.lock,
                  obscure: !_ver,
                  suffix: CupertinoButton(
                    padding: const EdgeInsets.only(right: 10),
                    minimumSize: Size.zero,
                    onPressed: () => setState(() => _ver = !_ver),
                    child: Icon(
                        _ver ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        color: CupertinoColors.systemGrey,
                        size: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _recordar = !_recordar),
                      child: Row(
                        children: [
                          Icon(
                            _recordar
                                ? CupertinoIcons.checkmark_square_fill
                                : CupertinoIcons.square,
                            color: _recordar
                                ? AppTheme.primary
                                : CupertinoColors.systemGrey,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          const Text('Recordar sesión',
                              style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/recuperar'),
                      child: const Text('¿Olvidaste tu contraseña?',
                          style:
                              TextStyle(fontSize: 13, color: AppTheme.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                PrimaryButton(text: 'Ingresar', onPressed: _ingresar),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(
                        child: Divider(color: CupertinoColors.systemGrey4)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('o',
                          style: TextStyle(color: CupertinoColors.systemGrey)),
                    ),
                    Expanded(
                        child: Divider(color: CupertinoColors.systemGrey4)),
                  ],
                ),
                const SizedBox(height: 14),
                _social(
                  texto: 'Continuar con Apple',
                  icon: CupertinoIcons.device_phone_portrait,
                  fondo: CupertinoColors.black,
                  textoColor: CupertinoColors.white,
                ),
                const SizedBox(height: 10),
                _social(
                  texto: 'Continuar con Google',
                  icon: CupertinoIcons.globe,
                  fondo: AppTheme.card(context),
                  textoColor: AppTheme.textColor(context),
                  borde: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _social({
    required String texto,
    required IconData icon,
    required Color fondo,
    required Color textoColor,
    bool borde = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(12),
        onPressed: () => showCupertinoDialog<void>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(texto),
            content:
                const Text('Este método de acceso aún no está configurado.'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(12),
            border:
                borde ? Border.all(color: CupertinoColors.systemGrey4) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textoColor, size: 20),
              const SizedBox(width: 8),
              Text(texto,
                  style: TextStyle(
                      color: textoColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Divider simple (Cupertino no trae uno propio).
class Divider extends StatelessWidget {
  final Color color;
  const Divider({super.key, required this.color});
  @override
  Widget build(BuildContext context) => Container(height: 1, color: color);
}
