import 'package:flutter/cupertino.dart';
import '../app_state.dart';
import '../db/database_helper.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';
import '../widgets/alumno_card.dart';
import 'detalle_alumno_screen.dart';
import 'registrar_alumno_screen.dart';
import 'filtros_screen.dart';

class ListarAlumnosScreen extends StatefulWidget {
  const ListarAlumnosScreen({super.key});
  @override
  State<ListarAlumnosScreen> createState() => _ListarAlumnosScreenState();
}

class _ListarAlumnosScreenState extends State<ListarAlumnosScreen> {
  String _busqueda = '';

  List<Alumno> _procesar(List<Alumno> lista) {
    var r = lista;
    // Filtro por estado
    switch (filtroEstado.value) {
      case FiltroEstado.aprobados:
        r = r.where((a) => a.aprobado).toList();
        break;
      case FiltroEstado.desaprobados:
        r = r.where((a) => !a.aprobado).toList();
        break;
      case FiltroEstado.todos:
        break;
    }
    // Búsqueda
    if (_busqueda.trim().isNotEmpty) {
      final q = _busqueda.toLowerCase();
      r = r.where((a) => a.nombreCompleto.toLowerCase().contains(q)).toList();
    }
    // Orden
    if (ordenPor.value.startsWith('Nombre')) {
      r.sort((a, b) => a.nombreCompleto.compareTo(b.nombreCompleto));
    } else if (ordenPor.value.startsWith('Nota')) {
      r.sort((a, b) => b.nota.compareTo(a.nota));
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Alumnos'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => const RegistrarAlumnoScreen())),
          child: const Icon(CupertinoIcons.add, size: 26),
        ),
      ),
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
                final todos = snap.data!;
                final aprobados = todos.where((a) => a.aprobado).length;
                final desaprobados = todos.length - aprobados;
                final lista = _procesar(todos);

                return Column(
                  children: [
                    // Búsqueda + filtro
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoSearchTextField(
                              placeholder: 'Buscar alumno...',
                              onChanged: (v) => setState(() => _busqueda = v),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (_) => const FiltrosScreen()),
                              );
                              setState(() {});
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                  CupertinoIcons.slider_horizontal_3,
                                  color: CupertinoColors.white,
                                  size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chips de estado
                    SizedBox(
                      height: 40,
                      child: ValueListenableBuilder<FiltroEstado>(
                        valueListenable: filtroEstado,
                        builder: (context, estado, __) {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            children: [
                              _chip('Todos (${todos.length})',
                                  FiltroEstado.todos, estado),
                              _chip('Aprobados ($aprobados)',
                                  FiltroEstado.aprobados, estado),
                              _chip('Desaprobados ($desaprobados)',
                                  FiltroEstado.desaprobados, estado),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: lista.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/listar_alumnos.png',
                                    width: 150,
                                    height: 130,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('No hay alumnos',
                                      style: TextStyle(
                                          color: CupertinoColors.systemGrey)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: lista.length,
                              itemBuilder: (_, i) => AlumnoCard(
                                alumno: lista[i],
                                onTap: () => Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (_) =>
                                        DetalleAlumnoScreen(alumno: lista[i]),
                                  ),
                                ),
                              ),
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

  Widget _chip(String texto, FiltroEstado valor, FiltroEstado actual) {
    final activo = valor == actual;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => filtroEstado.value = valor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activo ? AppTheme.primary : AppTheme.card(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: activo ? AppTheme.primary : CupertinoColors.systemGrey4),
          ),
          child: Text(texto,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: activo
                      ? CupertinoColors.white
                      : AppTheme.textColor(context))),
        ),
      ),
    );
  }
}
