import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

/// Botón principal (morado, estilo iOS).
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(14),
        padding: const EdgeInsets.symmetric(vertical: 14),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: CupertinoColors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: CupertinoColors.white)),
          ],
        ),
      ),
    );
  }
}

/// Botón secundario (borde morado).
class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  const OutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.55)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
            ],
            Text(text,
                style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Ilustración suave (placeholder): círculo lavanda con ícono.
class SoftIllustration extends StatelessWidget {
  final IconData icon;
  final double size;
  const SoftIllustration({super.key, required this.icon, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.lavender, Color(0xFFDDD6FE)],
        ),
      ),
      child: Icon(icon, size: size * 0.42, color: AppTheme.primary),
    );
  }
}

/// Tarjeta blanca redondeada con sombra suave.
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

/// Campo de texto estilo iOS con ícono.
class AppField extends StatelessWidget {
  final TextEditingController? controller;
  final String placeholder;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  const AppField({
    super.key,
    this.controller,
    required this.placeholder,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      padding: const EdgeInsets.all(14),
      style: TextStyle(color: AppTheme.textColor(context)),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Icon(icon, color: CupertinoColors.systemGrey, size: 20),
      ),
      suffix: suffix,
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
    );
  }
}

/// Fila de información (ícono + título + valor), estilo iOS.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String? valor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  const InfoRow({
    super.key,
    required this.icon,
    required this.titulo,
    this.valor,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppTheme.primary),
      title: Text(titulo, style: TextStyle(color: AppTheme.textColor(context))),
      trailing: trailing ??
          (valor != null
              ? Text(valor!,
                  style: const TextStyle(color: CupertinoColors.systemGrey))
              : const CupertinoListTileChevron()),
    );
  }
}
