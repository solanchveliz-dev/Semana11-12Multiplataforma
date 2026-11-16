import 'package:flutter/cupertino.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';

/// Tarjeta (Card) de un alumno para la lista.
class AlumnoCard extends StatelessWidget {
  final Alumno alumno;
  final VoidCallback onTap;
  const AlumnoCard({super.key, required this.alumno, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorEstado = alumno.aprobado ? AppTheme.success : AppTheme.danger;
    final fondoEstado =
        alumno.aprobado ? AppTheme.successBg : AppTheme.dangerBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/logo_academico.png',
              width: 46,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alumno.nombreCompleto,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textColor(context))),
                  const SizedBox(height: 2),
                  Text('Nota: ${alumno.nota.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 13, color: CupertinoColors.systemGrey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: fondoEstado, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    alumno.aprobado
                        ? 'assets/images/aprobado.png'
                        : 'assets/images/desaprobado.png',
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 4),
                  Text(alumno.estado,
                      style: TextStyle(
                          color: colorEstado,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(CupertinoIcons.chevron_right,
                size: 16, color: CupertinoColors.systemGrey3),
          ],
        ),
      ),
    );
  }
}
