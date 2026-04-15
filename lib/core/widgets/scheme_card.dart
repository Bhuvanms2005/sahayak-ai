import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SchemeCard extends StatelessWidget {
  final String title;
  final String description;
  final String eligibility;

  const SchemeCard({
    super.key,
    required this.title,
    required this.description,
    required this.eligibility,
  });

  Color getStatusColor() {
    switch (eligibility) {
      case "Eligible":
        return AppColors.secondary;
      case "Pending":
        return AppColors.tertiary;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Chip(
              label: Text(eligibility),
              backgroundColor: getStatusColor().withOpacity(0.1),
              labelStyle: TextStyle(color: getStatusColor()),
            ),
          ],
        ),
      ),
    );
  }
}