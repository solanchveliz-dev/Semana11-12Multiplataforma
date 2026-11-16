import 'package:flutter/cupertino.dart';
import '../app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class FiltrosScreen extends StatefulWidget {
  const FiltrosScreen({super.key});
  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  late FiltroEstado _estado;
  late String _orden;

  final _ordenes = const ['Nombre (A - Z)', 'Nota (mayor a menor)'];

  @override
  void initState() {
    super.initState();
    _estado = filtroEstado.value;
    _orden = ordenPor.value;
  }

  void _aplicar() {
    filtroEstado.value = _estado;
    ordenPor.value = _orden;
    Navigator.pop(context);
  }

  void _limpiar() {
    setState(() {
      _estado = FiltroEstado.todos;
      _orden = _ordenes.first;
    });
  }

  void _elegirOrden() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Ordenar por'),
        actions: _ordenes
            .map((o) => CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() => _orden = o);
                    Navigator.pop(ctx);
                  },
                  child: Text(o),
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Filtrar alumnos'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Estado',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey)),
                  const SizedBox(height: 8),
                  SectionCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _radio('Todos', FiltroEstado.todos),
                        _div(),
                        _radio('Aprobados', FiltroEstado.aprobados),
                        _div(),
                        _radio('Desaprobados', FiltroEstado.desaprobados),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Ordenar por',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey)),
                  const SizedBox(height: 8),
                  SectionCard(
                    padding: EdgeInsets.zero,
                    child: CupertinoListTile(
                      title: Text(_orden,
                          style: TextStyle(
                              color: AppTheme.textColor(context))),
                      trailing: const Icon(CupertinoIcons.chevron_down,
                          size: 18, color: CupertinoColors.systemGrey),
                      onTap: _elegirOrden,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: CupertinoButton(
                      onPressed: _limpiar,
                      child: const Text('Limpiar filtros',
                          style: TextStyle(color: AppTheme.primary)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(text: 'Aplicar', onPressed: _aplicar),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radio(String texto, FiltroEstado valor) {
    final activo = _estado == valor;
    return CupertinoListTile(
      title: Text(texto,
          style: TextStyle(color: AppTheme.textColor(context))),
      trailing: Icon(
        activo
            ? CupertinoIcons.largecircle_fill_circle
            : CupertinoIcons.circle,
        color: activo ? AppTheme.primary : CupertinoColors.systemGrey3,
      ),
      onTap: () => setState(() => _estado = valor),
    );
  }

  Widget _div() => Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 16),
      color: CupertinoColors.systemGrey5);
}
