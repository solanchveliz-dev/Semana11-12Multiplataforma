import 'package:flutter/cupertino.dart';

/// Estado global simple (sin paquetes externos).
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);
final ValueNotifier<bool> notificacionesNotifier = ValueNotifier<bool>(true);
final ValueNotifier<int> dataChanged = ValueNotifier<int>(0);

/// Filtro y orden compartidos entre la lista y la pantalla de filtros.
enum FiltroEstado { todos, aprobados, desaprobados }

final ValueNotifier<FiltroEstado> filtroEstado =
    ValueNotifier<FiltroEstado>(FiltroEstado.todos);
final ValueNotifier<String> ordenPor =
    ValueNotifier<String>('Nombre (A - Z)');

/// Usuario "logueado" de ejemplo (docente).
class SesionActual {
  static String nombre = 'Naomi Veliz';
  static String email = 'naomi.veliz@tecsup.edu.pe';
  static String telefono = '912 345 678';
  static String rol = 'Docente';
  static String ciclo = '2026-2';
}
