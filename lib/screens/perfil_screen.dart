import 'package:flutter/cupertino.dart';
import '../app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'editar_perfil_screen.dart';
import 'configuracion_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Mi Perfil'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(builder: (_) => const ConfiguracionScreen())),
          child: const Icon(CupertinoIcons.settings, size: 24),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              child: Column(
                children: [
                  Stack(
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
                            border: Border.all(
                                color: AppTheme.card(context), width: 2),
                          ),
                          child: const Icon(CupertinoIcons.camera_fill,
                              color: CupertinoColors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(SesionActual.nombre,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor(context))),
                  Text(SesionActual.rol,
                      style:
                          const TextStyle(color: CupertinoColors.systemGrey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  InfoRow(
                      icon: CupertinoIcons.mail,
                      titulo: 'Correo',
                      valor: SesionActual.email),
                  _div(),
                  InfoRow(
                      icon: CupertinoIcons.phone,
                      titulo: 'Teléfono',
                      valor: SesionActual.telefono),
                  _div(),
                  InfoRow(
                      icon: CupertinoIcons.briefcase,
                      titulo: 'Rol',
                      valor: SesionActual.rol),
                ],
              ),
            ),
            const SizedBox(height: 18),
            OutlineButton(
              text: 'Editar perfil',
              icon: CupertinoIcons.pencil,
              onPressed: () async {
                await Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) => const EditarPerfilScreen()));
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _div() => Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 52),
      color: CupertinoColors.systemGrey5);
}
