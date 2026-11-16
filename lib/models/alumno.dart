/// Modelo Alumno + conversión a/desde Map (Listas y Mapas).
class Alumno {
  final int? id;
  final String nombre;
  final String apellido;
  final double nota;

  Alumno({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.nota,
  });

  /// En Perú la nota mínima aprobatoria es 11 (escala vigesimal 0-20).
  bool get aprobado => nota >= 11;
  String get estado => aprobado ? 'Aprobado' : 'Desaprobado';
  String get nombreCompleto => '$nombre $apellido';

  String get iniciales {
    final n = nombre.isNotEmpty ? nombre[0] : '';
    final a = apellido.isNotEmpty ? apellido[0] : '';
    return (n + a).toUpperCase();
  }

  /// Objeto -> Map (para guardar en SQLite).
  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'nota': nota,
      };

  /// Map -> Objeto (al leer de SQLite).
  factory Alumno.fromMap(Map<String, dynamic> map) => Alumno(
        id: map['id'] as int?,
        nombre: map['nombre'] as String,
        apellido: map['apellido'] as String,
        nota: (map['nota'] as num).toDouble(),
      );

  Alumno copyWith({int? id, String? nombre, String? apellido, double? nota}) =>
      Alumno(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        nota: nota ?? this.nota,
      );
}
