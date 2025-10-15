import 'package:flutter/material.dart';

import '../../../../../theme/text_styles.dart';
import '../../../../../widgets/coming_soon_dialog.dart';

class PetHomeButtons extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final Widget navigatorPage;
  const PetHomeButtons({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.borderColor,
    required this.navigatorPage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => label == "Bookings"
          ? showComingSoonDialog(context)
          : Navigator.push(
              context, MaterialPageRoute(builder: (_) => navigatorPage)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: t700_16.copyWith(color: Colors.black),
            ),
            const SizedBox(width: 12),
            Icon(icon, size: 20, color: iconColor),
          ],
        ),
      ),
    );
  }
}
