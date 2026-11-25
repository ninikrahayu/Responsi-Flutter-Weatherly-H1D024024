import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionTitle({super.key, required this.title, this.trailing});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 4, height: 18, color: AppTheme.primary),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
      ),
      if (trailing != null)
        Text(
          trailing!,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
    ],
  );
}
