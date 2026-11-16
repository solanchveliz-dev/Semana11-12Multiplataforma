import 'package:flutter/cupertino.dart';
import '../app_state.dart';
import '../db/database_helper.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/charts.dart';
import 'reporte_screen.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});
  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  String _ciclo = '2026-2';
  final _ciclos = const ['2026-2', '2026-1', '2025-2'];

  void _elegirCiclo() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Seleccionar ciclo'),
        actions: _ciclos
            .map((c) => CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() => _ciclo = c);
                    Navigator.pop(ctx);
                  },
                  child: Text(c),
                ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Estadísticas')),
      child: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: dataChanged,
          builder: (context, _, __) {
            return FutureBuilder<List<Alumno>>(
              future: DatabaseHelper.instance.leerTodos(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                final alumnos = snap.data!;
                final total = alumnos.length;
                final aprobados = alumnos.where((a) => a.aprobado).length;
                final desaprobados = total - aprobados;
                final promedio = total == 0
                    ? 0.0
                    : alumnos.map((a) => a.nota).reduce((x, y) => x + y) /
                        total;
                final pctA = total == 0 ? 0 : (aprobados / total * 100).round();
                final pctD = total == 0 ? 0 : 100 - pctA;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Ciclo
                    SectionCard(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _elegirCiclo,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ciclo  $_ciclo',
                                style: TextStyle(
                                    color: AppTheme.textColor(context),
                                    fontWeight: FontWeight.w600)),
                            const Icon(CupertinoIcons.chevron_down,
                                size: 18, color: CupertinoColors.systemGrey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dona + leyenda
                    SectionCard(
                      child: Column(
                        children: [
                          DonutChart(
                              aprobados: aprobados, desaprobados: desaprobados),
                          const SizedBox(height: 16),
                          _leyenda(
                              AppTheme.success, 'Aprobados', aprobados, pctA),
                          const SizedBox(height: 8),
                          _leyenda(AppTheme.danger, 'Desaprobados',
                              desaprobados, pctD),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Promedio
                    SectionCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppTheme.lavender,
                                borderRadius: BorderRadius.circular(12)),
                            child: Image.asset(
                              'assets/images/promedio_notas.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Promedio general',
                                  style: TextStyle(
                                      color: CupertinoColors.systemGrey)),
                              Text('${promedio.toStringAsFixed(1)} / 20',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColor(context))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Evolución
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Evolución de notas',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textColor(context))),
                          const SizedBox(height: 10),
                          const LineChart(
                            valores: [13, 15, 14, 16],
                            etiquetas: ['E1', 'E2', 'E3', 'E4'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: 'Reporte de notas',
                      icon: CupertinoIcons.doc_text_fill,
                      onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (_) => const ReporteScreen()),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _leyenda(Color color, String texto, int valor, int pct) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(texto,
                style: TextStyle(color: AppTheme.textColor(context)))),
        Text('$valor',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor(context))),
        const SizedBox(width: 10),
        Text('$pct%',
            style: const TextStyle(color: CupertinoColors.systemGrey)),
      ],
    );
  }
}
