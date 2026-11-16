import 'package:flutter/cupertino.dart';
import 'inicio_screen.dart';
import 'listar_alumnos_screen.dart';
import 'estadisticas_screen.dart';
import 'perfil_screen.dart';

/// Navegación principal con barra de pestañas estilo iOS.
class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: const Color(0xFF7C3AED),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2_fill), label: 'Alumnos'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar_alt_fill),
              label: 'Estadísticas'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_crop_circle), label: 'Perfil'),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (_) => const InicioScreen());
          case 1:
            return CupertinoTabView(
                builder: (_) => const ListarAlumnosScreen());
          case 2:
            return CupertinoTabView(
                builder: (_) => const EstadisticasScreen());
          default:
            return CupertinoTabView(builder: (_) => const PerfilScreen());
        }
      },
    );
  }
}
