import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'nothing_card.dart';

class WeatherDetailCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  const WeatherDetailCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => NothingCard(
    radius: 18,
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: AppTheme.dotText(fontSize: 26)),
        ),
      ],
    ),
  );
}
