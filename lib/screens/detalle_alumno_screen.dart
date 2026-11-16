import 'package:flutter/cupertino.dart';
import '../db/database_helper.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'registrar_alumno_screen.dart';

class DetalleAlumnoScreen extends StatelessWidget {
  final Alumno alumno;
  const DetalleAlumnoScreen({super.key, required this.alumno});

  @override
  Widget build(BuildContext context) {
    final colorEstado = alumno.aprobado ? AppTheme.success : AppTheme.danger;
    final fondoEstado =
        alumno.aprobado ? AppTheme.successBg : AppTheme.dangerBg;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detalle del Alumno'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_academico.png',
                    width: 96,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(alumno.nombreCompleto,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor(context))),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        color: fondoEstado,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          alumno.aprobado
                              ? 'assets/images/aprobado.png'
                              : 'assets/images/desaprobado.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 5),
                        Text(alumno.estado,
                            style: TextStyle(
                                color: colorEstado,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  InfoRow(
                      icon: CupertinoIcons.person,
                      titulo: 'Nombre',
                      valor: alumno.nombre),
                  _div(),
                  InfoRow(
                      icon: CupertinoIcons.person_badge_plus,
                      titulo: 'Apellido',
                      valor: alumno.apellido),
                  _div(),
                  InfoRow(
                      icon: CupertinoIcons.chart_bar,
                      titulo: 'Nota',
                      valor: '${alumno.nota.toStringAsFixed(0)} / 20'),
                  _div(),
                  InfoRow(
                      icon: CupertinoIcons.info_circle,
                      titulo: 'Estado',
                      valor: alumno.estado),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    text: 'Editar',
                    icon: CupertinoIcons.pencil,
                    onPressed: () => Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                          builder: (_) =>
                              RegistrarAlumnoScreen(alumno: alumno)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlineButton(
                    text: 'Eliminar',
                    icon: CupertinoIcons.trash,
                    color: AppTheme.danger,
                    onPressed: () => _confirmarEliminar(context),
                  ),
                ),
              ],
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

  void _confirmarEliminar(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppTheme.card(ctx),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () => Navigator.pop(ctx),
                  child: Icon(
                    CupertinoIcons.xmark,
                    size: 16,
                    color: CupertinoColors.secondaryLabel.resolveFrom(ctx),
                  ),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    color: AppTheme.dangerBg, shape: BoxShape.circle),
                child: const Icon(CupertinoIcons.trash_fill,
                    color: AppTheme.danger, size: 26),
              ),
              const SizedBox(height: 14),
              Text('Eliminar alumno',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(ctx))),
              const SizedBox(height: 6),
              Text(
                '¿Estás seguro de que deseas eliminar a ${alumno.nombreCompleto}?',
                textAlign: TextAlign.center,
                style: const TextStyle(color: CupertinoColors.systemGrey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancelar',
                          style: TextStyle(color: AppTheme.primary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      color: AppTheme.danger,
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onPressed: () async {
                        await DatabaseHelper.instance.eliminar(alumno.id!);
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Eliminar',
                          style: TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
