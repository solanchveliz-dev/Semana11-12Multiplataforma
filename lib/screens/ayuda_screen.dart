import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Ayuda y soporte')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 132,
                height: 132,
                decoration: const BoxDecoration(
                  color: AppTheme.lavender,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.headphones,
                  size: 72,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text('¿Necesitas ayuda?',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context))),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Contáctanos o consulta nuestras preguntas frecuentes.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
            ),
            const SizedBox(height: 22),
            SectionCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.question_circle,
                        color: AppTheme.primary),
                    title: const Text('Preguntas frecuentes'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _mostrarAyuda(
                      context,
                      'Preguntas frecuentes',
                      'Puedes registrar alumnos, editar sus datos y revisar sus notas desde la pestaña Alumnos.',
                    ),
                  ),
                  Container(
                      height: 0.5,
                      margin: const EdgeInsets.only(left: 52),
                      color: CupertinoColors.systemGrey5),
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.chat_bubble_2_fill,
                        color: AppTheme.primary),
                    title: const Text('Contactar soporte'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _mostrarAyuda(
                      context,
                      'Contactar soporte',
                      'Contacta al administrador de tu institución para recibir ayuda.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAyuda(BuildContext context, String titulo, String mensaje) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(mensaje),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
