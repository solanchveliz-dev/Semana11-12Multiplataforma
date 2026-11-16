import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primary, AppTheme.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 132,
                  height: 132,
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/logo_academico.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Gestión de\nAlumnos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 30,
                        height: 1.15,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 28),
                const CupertinoActivityIndicator(color: CupertinoColors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
