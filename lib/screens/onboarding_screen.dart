import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _slides = const [
    _Slide(
      imagen: 'assets/images/bienvenida_3d.png',
      titulo: 'Registra alumnos',
      texto: 'Agrega y gestiona la información académica de tus estudiantes.',
    ),
    _Slide(
      imagen: 'assets/images/estadisticas_3d.png',
      titulo: 'Controla las notas',
      texto:
          'Visualiza el rendimiento y el estado de aprobación de forma rápida.',
    ),
    _Slide(
      imagen: 'assets/images/calendario_3d.png',
      titulo: 'Obtén estadísticas',
      texto: 'Analiza el avance académico con reportes claros y confiables.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _irLogin() => Navigator.pushReplacementNamed(context, '/login');

  void _siguiente() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _irLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final esUltima = _page == _slides.length - 1;
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final s = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 260,
                          height: 230,
                          child: Image.asset(
                            s.imagen,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(s.titulo,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor(context))),
                        const SizedBox(height: 12),
                        Text(s.texto,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: CupertinoColors.systemGrey)),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicadores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? AppTheme.primary
                        : CupertinoColors.systemGrey4,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  PrimaryButton(
                    text: esUltima ? 'Comenzar' : 'Siguiente',
                    onPressed: _siguiente,
                  ),
                  const SizedBox(height: 6),
                  CupertinoButton(
                    onPressed: _irLogin,
                    child: const Text('Omitir',
                        style: TextStyle(color: CupertinoColors.systemGrey)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final String imagen;
  final String titulo;
  final String texto;
  const _Slide(
      {required this.imagen, required this.titulo, required this.texto});
}
