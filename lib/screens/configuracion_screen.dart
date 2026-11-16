import 'package:flutter/cupertino.dart';
import '../app_state.dart';
import '../theme/app_theme.dart';
import 'recuperar_password_screen.dart';
import 'ayuda_screen.dart';
import 'acerca_screen.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});
  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  String _idioma = 'Español';

  void _elegirIdioma() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Idioma'),
        actions: ['Español', 'English']
            .map((i) => CupertinoActionSheetAction(
                onPressed: () {
                  setState(() => _idioma = i);
                  Navigator.pop(ctx);
                },
                child: Text(i)))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
      ),
    );
  }

  void _cerrarSesion() {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de la aplicación?'),
        actions: [
          CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil('/login', (r) => false);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Configuración')),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 12),
            CupertinoListSection.insetGrouped(
              header: const Text('CUENTA'),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.lock_fill,
                      color: AppTheme.primary),
                  title: const Text('Cambiar contraseña'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => const RecuperarPasswordScreen())),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('PREFERENCIAS'),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.bell_fill,
                      color: AppTheme.primary),
                  title: const Text('Notificaciones'),
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: notificacionesNotifier,
                    builder: (_, v, __) => CupertinoSwitch(
                        value: v,
                        onChanged: (x) => notificacionesNotifier.value = x),
                  ),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.moon_fill,
                      color: AppTheme.primary),
                  title: const Text('Modo oscuro'),
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: darkModeNotifier,
                    builder: (_, v, __) => CupertinoSwitch(
                        value: v, onChanged: (x) => darkModeNotifier.value = x),
                  ),
                ),
                CupertinoListTile(
                  leading:
                      const Icon(CupertinoIcons.globe, color: AppTheme.primary),
                  title: const Text('Idioma'),
                  additionalInfo: Text(_idioma),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _elegirIdioma,
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('INFORMACIÓN'),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.question_circle_fill,
                      color: AppTheme.primary),
                  title: const Text('Ayuda y soporte'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => const AyudaScreen())),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.info_circle_fill,
                      color: AppTheme.primary),
                  title: const Text('Acerca de la app'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => const AcercaScreen())),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: Image.asset(
                    'assets/images/cerrar_sesion.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  title: const Text('Cerrar sesión',
                      style: TextStyle(color: AppTheme.danger)),
                  onTap: _cerrarSesion,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
