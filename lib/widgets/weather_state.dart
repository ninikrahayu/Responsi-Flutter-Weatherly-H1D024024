import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'nothing_card.dart';
import 'dot_pattern.dart';

class WeatherState extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool isLoading;
  const WeatherState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Stack(
          children: [
            NothingCard(
              padding: const EdgeInsets.all(28),
              radius: 28,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const CircularProgressIndicator(color: AppTheme.primary)
                  else
                    Icon(icon, size: 48, color: AppTheme.primary),
                  const SizedBox(height: 24),
                  Text(
                    title.toUpperCase(),
                    style: AppTheme.dotText(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                  if (buttonText != null && onPressed != null) ...[
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: onPressed,
                      child: Text(buttonText!),
                    ),
                  ],
                ],
              ),
            ),
            const Positioned(
              top: 12,
              right: 12,
              child: IgnorePointer(
                child: DotPattern(width: 40, height: 40, spacing: 8),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
