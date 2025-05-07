import 'package:flutter/material.dart';
import 'package:frontend/utils/extensions/build_context.dart';

class CustomErrorWidget extends StatelessWidget {
  final void Function()? onRetry;

  const CustomErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 20),
          Text(
            context.t('wentWrong'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: onRetry,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              padding: EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
              ),
              child: Center(
                child: Text(
                  context.t('retry'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
