import 'package:flutter/material.dart';

import '../theme/space_theme.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final IconData? icon;
  const SectionTitle(this.text, {super.key, this.icon});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: SpaceColors.accentBlue, size: 20),
          if (icon != null) const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: theme.titleSmall?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white24, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
