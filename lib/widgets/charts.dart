import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

/// Gráfico de dona (aprobados vs desaprobados) con CustomPainter.
class DonutChart extends StatelessWidget {
  final int aprobados;
  final int desaprobados;
  const DonutChart({
    super.key,
    required this.aprobados,
    required this.desaprobados,
  });

  @override
  Widget build(BuildContext context) {
    final total = aprobados + desaprobados;
    return SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: _DonutPainter(
          aprobados: aprobados.toDouble(),
          desaprobados: desaprobados.toDouble(),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$total',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor(context),
                ),
              ),
              const Text(
                'Alumnos',
                style: TextStyle(
                    fontSize: 13, color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double aprobados;
  final double desaprobados;
  _DonutPainter({required this.aprobados, required this.desaprobados});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 20.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final total = aprobados + desaprobados;

    final base = Paint()
      ..color = CupertinoColors.systemGrey5
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, base);

    if (total <= 0) return;

    const start = -math.pi / 2;
    final sweepA = 2 * math.pi * (aprobados / total);
    final sweepD = 2 * math.pi * (desaprobados / total);

    final pA = Paint()
      ..color = AppTheme.success
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    final pD = Paint()
      ..color = AppTheme.danger
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;

    canvas.drawArc(rect, start, sweepA, false, pA);
    canvas.drawArc(rect, start + sweepA, sweepD, false, pD);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.aprobados != aprobados || old.desaprobados != desaprobados;
}

/// Gráfico de línea simple (evolución de notas) con CustomPainter.
class LineChart extends StatelessWidget {
  final List<double> valores;
  final List<String> etiquetas;
  final double maxY;
  const LineChart({
    super.key,
    required this.valores,
    required this.etiquetas,
    this.maxY = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _LinePainter(valores: valores, maxY: maxY),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: etiquetas
                .map((e) => Text(e,
                    style: const TextStyle(
                        fontSize: 11, color: CupertinoColors.systemGrey)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> valores;
  final double maxY;
  _LinePainter({required this.valores, required this.maxY});

  @override
  void paint(Canvas canvas, Size size) {
    if (valores.isEmpty) return;

    // Líneas guía horizontales
    final grid = Paint()
      ..color = CupertinoColors.systemGrey5
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final dx = valores.length == 1
        ? 0.0
        : size.width / (valores.length - 1);

    Offset point(int i) {
      final x = dx * i;
      final y = size.height - (valores[i] / maxY) * size.height;
      return Offset(x, y.clamp(0.0, size.height).toDouble());
    }

    // Área bajo la curva
    final area = Path()..moveTo(0, size.height);
    for (int i = 0; i < valores.length; i++) {
      area.lineTo(point(i).dx, point(i).dy);
    }
    area.lineTo(size.width, size.height);
    area.close();
    canvas.drawPath(
      area,
      Paint()..color = AppTheme.primary.withValues(alpha: 0.12),
    );

    // Línea
    final linePaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(point(0).dx, point(0).dy);
    for (int i = 1; i < valores.length; i++) {
      path.lineTo(point(i).dx, point(i).dy);
    }
    canvas.drawPath(path, linePaint);

    // Puntos
    final dot = Paint()..color = AppTheme.primary;
    final dotIn = Paint()..color = CupertinoColors.white;
    for (int i = 0; i < valores.length; i++) {
      canvas.drawCircle(point(i), 5, dot);
      canvas.drawCircle(point(i), 2.5, dotIn);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => old.valores != valores;
}
