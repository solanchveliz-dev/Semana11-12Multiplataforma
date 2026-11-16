import 'package:flutter/cupertino.dart';
import '../db/database_helper.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class VistaReporteScreen extends StatelessWidget {
  final String ciclo;
  const VistaReporteScreen({super.key, required this.ciclo});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Reporte'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.share, size: 22, color: AppTheme.primary),
            SizedBox(width: 16),
            Icon(CupertinoIcons.printer, size: 22, color: AppTheme.primary),
          ],
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<List<Alumno>>(
          future: DatabaseHelper.instance.leerTodos(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final alumnos = snap.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.doc_text_fill,
                              color: AppTheme.primary),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reporte de Alumnos',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColor(context))),
                              Text('Ciclo: $ciclo',
                                  style: const TextStyle(
                                      color: CupertinoColors.systemGrey,
                                      fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Encabezado tabla
                      _fila(context,
                          c1: 'Nº',
                          c2: 'Alumno',
                          c3: 'Nota',
                          c4: 'Estado',
                          encabezado: true),
                      const SizedBox(height: 4),
                      ...List.generate(alumnos.length, (i) {
                        final a = alumnos[i];
                        return _fila(context,
                            c1: '${i + 1}',
                            c2: a.nombreCompleto,
                            c3: a.nota.toStringAsFixed(0),
                            c4: a.estado,
                            aprobado: a.aprobado);
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _fila(BuildContext context,
      {required String c1,
      required String c2,
      required String c3,
      required String c4,
      bool encabezado = false,
      bool aprobado = true}) {
    final estiloBase = TextStyle(
      color:
          encabezado ? CupertinoColors.systemGrey : AppTheme.textColor(context),
      fontWeight: encabezado ? FontWeight.w600 : FontWeight.normal,
      fontSize: 13,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: encabezado
          ? null
          : const BoxDecoration(
              border:
                  Border(top: BorderSide(color: CupertinoColors.systemGrey5))),
      child: Row(
        children: [
          SizedBox(width: 28, child: Text(c1, style: estiloBase)),
          Expanded(child: Text(c2, style: estiloBase)),
          SizedBox(width: 44, child: Text(c3, style: estiloBase)),
          SizedBox(
            width: 92,
            child: encabezado
                ? Text(c4, style: estiloBase)
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            aprobado ? AppTheme.successBg : AppTheme.dangerBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(c4,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: aprobado
                                  ? AppTheme.success
                                  : AppTheme.danger)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
