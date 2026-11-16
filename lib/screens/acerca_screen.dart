import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Acerca de la app')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/logo_academico.png',
                width: 120,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text('Gestión de Alumnos',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context))),
            ),
            const Center(
              child: Text('Versión 1.0.0',
                  style: TextStyle(color: CupertinoColors.systemGrey)),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Aplicación para registrar, consultar y gestionar las notas y el rendimiento de los alumnos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CupertinoColors.systemGrey),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SectionCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const InfoRow(
                      icon: CupertinoIcons.doc_text,
                      titulo: 'Términos y condiciones'),
                  Container(
                      height: 0.5,
                      margin: const EdgeInsets.only(left: 52),
                      color: CupertinoColors.systemGrey5),
                  const InfoRow(
                      icon: CupertinoIcons.shield_lefthalf_fill,
                      titulo: 'Política de privacidad'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
