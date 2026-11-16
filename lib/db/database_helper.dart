import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../app_state.dart';
import '../models/alumno.dart';

const _alumnosEjemplo = <Map<String, dynamic>>[
  {'nombre': 'Ana', 'apellido': 'Torres', 'nota': 18},
  {'nombre': 'Luis', 'apellido': 'Garcia', 'nota': 12},
  {'nombre': 'Maria', 'apellido': 'Lopez', 'nota': 9},
  {'nombre': 'Carlos', 'apellido': 'Ruiz', 'nota': 15},
  {'nombre': 'Beatriz', 'apellido': 'Mendoza', 'nota': 20},
  {'nombre': 'Daniela', 'apellido': 'Vargas', 'nota': 20},
  {'nombre': 'Diego', 'apellido': 'Ramos', 'nota': 10},
  {'nombre': 'Elena', 'apellido': 'Castro', 'nota': 20},
  {'nombre': 'Fabian', 'apellido': 'Paredes', 'nota': 20},
  {'nombre': 'Gabriela', 'apellido': 'Flores', 'nota': 8},
  {'nombre': 'Hugo', 'apellido': 'Salazar', 'nota': 17},
  {'nombre': 'Isabella', 'apellido': 'Mora', 'nota': 20},
  {'nombre': 'Javier', 'apellido': 'Rojas', 'nota': 16},
  {'nombre': 'Karen', 'apellido': 'Vega', 'nota': 20},
  {'nombre': 'Leonardo', 'apellido': 'Cruz', 'nota': 7},
  {'nombre': 'Mariana', 'apellido': 'Reyes', 'nota': 20},
  {'nombre': 'Nicolas', 'apellido': 'Aguilar', 'nota': 17},
  {'nombre': 'Olivia', 'apellido': 'Campos', 'nota': 5},
  {'nombre': 'Paola', 'apellido': 'Herrera', 'nota': 20},
  {'nombre': 'Rafael', 'apellido': 'Ortega', 'nota': 17},
  {'nombre': 'Sofia', 'apellido': 'Navarro', 'nota': 17},
  {'nombre': 'Tomas', 'apellido': 'Mendoza', 'nota': 16},
  {'nombre': 'Valeria', 'apellido': 'Soto', 'nota': 20},
  {'nombre': 'Esteban', 'apellido': 'Paz', 'nota': 9},
];

class DatabaseHelper {
  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();

  final List<Alumno> _mem = [];
  bool _memInit = false;
  int _memId = 1;

  void _seedMem() {
    if (_memInit) return;
    _memInit = true;
    _mem.addAll(_alumnosEjemplo.map(
      (alumno) => Alumno.fromMap({...alumno, 'id': _memId++}),
    ));
  }

  static Database? _database;
  Future<Database> get database async {
    _database ??= await _initDB('alumnos.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE alumnos (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, apellido TEXT NOT NULL, nota REAL NOT NULL)');
    for (final alumno in _alumnosEjemplo) {
      await db.insert('alumnos', alumno);
    }
  }

  void _notificar() => dataChanged.value++;

  Future<Alumno> crear(Alumno a) async {
    if (kIsWeb) {
      _seedMem();
      final nuevo = a.copyWith(id: _memId++);
      _mem.add(nuevo);
      _notificar();
      return nuevo;
    }
    final db = await instance.database;
    final id = await db.insert('alumnos', a.toMap()..remove('id'));
    _notificar();
    return a.copyWith(id: id);
  }

  Future<List<Alumno>> leerTodos() async {
    if (kIsWeb) {
      _seedMem();
      final lista = [..._mem];
      lista.sort((x, y) => x.nombre.compareTo(y.nombre));
      return lista;
    }
    final db = await instance.database;
    final result = await db.query('alumnos', orderBy: 'nombre ASC');
    return result.map((m) => Alumno.fromMap(m)).toList();
  }

  Future<int> actualizar(Alumno a) async {
    if (kIsWeb) {
      final i = _mem.indexWhere((x) => x.id == a.id);
      if (i >= 0) _mem[i] = a;
      _notificar();
      return 1;
    }
    final db = await instance.database;
    final n = await db
        .update('alumnos', a.toMap(), where: 'id = ?', whereArgs: [a.id]);
    _notificar();
    return n;
  }

  Future<int> eliminar(int id) async {
    if (kIsWeb) {
      _mem.removeWhere((x) => x.id == id);
      _notificar();
      return 1;
    }
    final db = await instance.database;
    final n = await db.delete('alumnos', where: 'id = ?', whereArgs: [id]);
    _notificar();
    return n;
  }
}
