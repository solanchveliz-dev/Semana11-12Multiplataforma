import 'package:flutter/cupertino.dart';
import '../app_state.dart';
import '../db/database_helper.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'listar_alumnos_screen.dart';
import 'registrar_alumno_screen.dart';
import 'estadisticas_screen.dart';
import 'notificaciones_screen.dart';

/// Dashboard / Inicio.
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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

                return ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryLight],
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hola, ${SesionActual.nombre.split(' ').first} 👋',
                                      style: const TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    const Text('Docente',
                                        style: TextStyle(
                                            color: Color(0xFFDCD0FF))),
                                  ],
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                onPressed: () => Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (_) =>
                                        const NotificacionesScreen(),
                                  ),
                                ),
                                child: const Icon(CupertinoIcons.bell_fill,
                                    color: CupertinoColors.white, size: 24),
                              ),
                              const SizedBox(width: 10),
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/perfil_docente.png',
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x18000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lavender,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.asset(
                                    'assets/images/alumnos_grupo.png',
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Alumnos registrados',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      Text(
                                        '$total',
                                        style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textColor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _miniStat(context,
                                    imagen: 'assets/images/aprobado.png',
                                    fondo: AppTheme.successBg,
                                    valor: '$aprobados',
                                    label: 'Aprobados'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _miniStat(context,
                                    imagen: 'assets/images/desaprobado.png',
                                    fondo: AppTheme.dangerBg,
                                    valor: '$desaprobados',
                                    label: 'Desaprobados'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SectionCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                InfoRow(
                                  icon: CupertinoIcons.person_2_fill,
                                  titulo: 'Gestionar alumnos',
                                  onTap: () => Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          const ListarAlumnosScreen(),
                                    ),
                                  ),
                                ),
                                _div(),
                                InfoRow(
                                  icon: CupertinoIcons.add_circled_solid,
                                  titulo: 'Registrar alumno',
                                  onTap: () => Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          const RegistrarAlumnoScreen(),
                                    ),
                                  ),
                                ),
                                _div(),
                                InfoRow(
                                  icon: CupertinoIcons.chart_bar_alt_fill,
                                  titulo: 'Estadísticas',
                                  onTap: () => Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          const EstadisticasScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _miniStat(BuildContext context,
      {required String imagen,
      required Color fondo,
      required String valor,
      required String label}) {
    return SectionCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: fondo, borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              imagen,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(valor,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context))),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: CupertinoColors.systemGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _div() => Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 52),
      color: CupertinoColors.systemGrey5);
}
