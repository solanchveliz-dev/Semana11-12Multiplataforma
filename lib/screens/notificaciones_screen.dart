import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      _Noti(
        icon: CupertinoIcons.doc_checkmark_fill,
        color: AppTheme.primary,
        imagen: 'assets/images/notificaciones_3d.png',
        titulo: 'Nota registrada',
        texto: 'Se registró la nota de Ana Torres.',
        tiempo: 'Hace 2 horas',
      ),
      _Noti(
        icon: CupertinoIcons.person_add_solid,
        color: AppTheme.success,
        titulo: 'Nuevo alumno',
        texto: 'Se agregó a Luis García.',
        tiempo: 'Ayer',
      ),
      _Noti(
        icon: CupertinoIcons.chart_bar_alt_fill,
        color: CupertinoColors.systemOrange,
        titulo: 'Reporte listo',
        texto: 'Tu reporte del ciclo 2026-2 está disponible.',
        tiempo: 'Hace 2 días',
      ),
    ];

    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Notificaciones')),
      child: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final n = items[i];
            return SectionCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: n.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12)),
                    child: n.imagen == null
                        ? Icon(n.icon, color: n.color)
                        : Image.asset(
                            n.imagen!,
                            width: 34,
                            height: 34,
                            fit: BoxFit.contain,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.titulo,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textColor(context))),
                        const SizedBox(height: 2),
                        Text(n.texto,
                            style: const TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(n.tiempo,
                            style: const TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 11)),
                      ],
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right,
                      size: 16, color: CupertinoColors.systemGrey3),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Noti {
  final IconData icon;
  final Color color;
  final String? imagen;
  final String titulo;
  final String texto;
  final String tiempo;
  const _Noti({
    required this.icon,
    required this.color,
    this.imagen,
    required this.titulo,
    required this.texto,
    required this.tiempo,
  });
}
