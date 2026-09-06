import 'package:flutter/material.dart';

class FastingTimer extends StatelessWidget {
  final String remainingTime;

  const FastingTimer({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              remainingTime,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 4),
            Text('restantes', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
