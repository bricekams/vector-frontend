import 'package:flutter/material.dart';
import 'package:frontend/utils/extensions/build_context.dart';

class ToSmallScreenErrorScreen extends StatelessWidget {
  const ToSmallScreenErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            context.t('loadOnBiggerScreen'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
