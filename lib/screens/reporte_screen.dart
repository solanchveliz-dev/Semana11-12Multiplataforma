import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'vista_reporte_screen.dart';

class ReporteScreen extends StatefulWidget {
  const ReporteScreen({super.key});
  @override
  State<ReporteScreen> createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  String _ciclo = '2026-2';
  String _formato = 'PDF';
  final _ciclos = const ['2026-2', '2026-1', '2025-2'];

  void _elegirCiclo() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Ciclo'),
        actions: _ciclos
            .map((c) => CupertinoActionSheetAction(
                onPressed: () {
                  setState(() => _ciclo = c);
                  Navigator.pop(ctx);
                },
                child: Text(c)))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
          middle: Text('Reporte de notas')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Ciclo',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.systemGrey)),
            const SizedBox(height: 8),
            SectionCard(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _elegirCiclo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_ciclo,
                        style: TextStyle(
                            color: AppTheme.textColor(context))),
                    const Icon(CupertinoIcons.chevron_down,
                        size: 18, color: CupertinoColors.systemGrey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Formato',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.systemGrey)),
            const SizedBox(height: 8),
            SectionCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _radioFormato('PDF', CupertinoIcons.doc_text_fill),
                  Container(
                      height: 0.5,
                      margin: const EdgeInsets.only(left: 52),
                      color: CupertinoColors.systemGrey5),
                  _radioFormato('Excel', CupertinoIcons.table_fill),
                ],
              ),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              text: 'Descargar reporte',
              icon: CupertinoIcons.cloud_download_fill,
              onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                  builder: (_) => VistaReporteScreen(ciclo: _ciclo))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioFormato(String valor, IconData icon) {
    final activo = _formato == valor;
    return CupertinoListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title:
          Text(valor, style: TextStyle(color: AppTheme.textColor(context))),
      trailing: Icon(
        activo
            ? CupertinoIcons.largecircle_fill_circle
            : CupertinoIcons.circle,
        color: activo ? AppTheme.primary : CupertinoColors.systemGrey3,
      ),
      onTap: () => setState(() => _formato = valor),
    );
  }
}
