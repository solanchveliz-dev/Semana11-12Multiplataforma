import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class VerificarCodigoScreen extends StatefulWidget {
  const VerificarCodigoScreen({super.key});
  @override
  State<VerificarCodigoScreen> createState() => _VerificarCodigoScreenState();
}

class _VerificarCodigoScreenState extends State<VerificarCodigoScreen> {
  int _segundos = 49;
  Timer? _timer;
  final _controllers =
      List<TextEditingController>.generate(6, (_) => TextEditingController());
  final _focusNodes = List<FocusNode>.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_segundos == 0) {
        t.cancel();
      } else {
        setState(() => _segundos--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _reenviarCodigo() {
    if (_segundos > 0) return;
    setState(() => _segundos = 49);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundos <= 1) {
        timer.cancel();
        setState(() => _segundos = 0);
      } else {
        setState(() => _segundos--);
      }
    });
  }

  String get _tiempo {
    final m = (_segundos ~/ 60).toString().padLeft(2, '0');
    final s = (_segundos % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Verifica tu correo'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/verificacion_3d.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 22),
              Text('Verifica tu correo',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context))),
              const SizedBox(height: 8),
              const Text('Ingresa el código de 6 dígitos enviado a tu correo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CupertinoColors.systemGrey)),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, _casilla),
              ),
              const SizedBox(height: 18),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _segundos == 0 ? _reenviarCodigo : null,
                child: Text(
                  _segundos > 0
                      ? 'Reenviar código en  $_tiempo'
                      : 'Reenviar código',
                  style: TextStyle(
                    color: _segundos == 0
                        ? AppTheme.primary
                        : CupertinoColors.systemGrey,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                text: 'Verificar',
                onPressed: () {
                  if (_controllers
                      .any((controller) => controller.text.isEmpty)) {
                    showCupertinoDialog<void>(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Código incompleto'),
                        content: const Text('Ingresa los 6 dígitos recibidos.'),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Entendido'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.pushNamed(context, '/nueva-password');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _casilla(int index) {
    return Container(
      width: 46,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
      child: CupertinoTextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const BoxDecoration(),
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor(context)),
        onChanged: (value) {
          if (value.isNotEmpty && index < _focusNodes.length - 1) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
