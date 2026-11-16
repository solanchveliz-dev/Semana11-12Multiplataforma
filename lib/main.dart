import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/recuperar_password_screen.dart';
import 'screens/verificar_codigo_screen.dart';
import 'screens/nueva_password_screen.dart';
import 'screens/home_tabs.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, _) {
        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: 'Gestion de Alumnos',
          theme: isDark ? AppTheme.dark : AppTheme.light,
          builder: (context, child) => PhoneFrame(child: child),
          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/onboarding': (_) => const OnboardingScreen(),
            '/login': (_) => const LoginScreen(),
            '/recuperar': (_) => const RecuperarPasswordScreen(),
            '/verificar': (_) => const VerificarCodigoScreen(),
            '/nueva-password': (_) => const NuevaPasswordScreen(),
            '/home': (_) => const HomeTabs(),
          },
        );
      },
    );
  }
}

class PhoneFrame extends StatelessWidget {
  final Widget? child;
  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final content = child ?? const SizedBox.shrink();
    if (!kIsWeb) return content;
    final media = MediaQuery.of(context);
    const w = 390.0;
    const h = 844.0;
    return ColoredBox(
      color: const Color(0xFF0E0E12),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: CupertinoColors.black,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(color: Color(0x66000000), blurRadius: 40, spreadRadius: 4),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(42),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: MediaQuery(
                        data: media.copyWith(
                          size: const Size(w - 20, h - 20),
                          padding: const EdgeInsets.only(top: 46, bottom: 22),
                          viewPadding: const EdgeInsets.only(top: 46, bottom: 22),
                        ),
                        child: content,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 118,
                          height: 30,
                          decoration: BoxDecoration(
                            color: CupertinoColors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
