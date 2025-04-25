import 'package:flutter/material.dart';
import 'package:frontend/providers/augment.dart';
import 'package:frontend/ui/screens/home/home.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:provider/provider.dart';

import 'augmentation_tile.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 400,
      color: Theme.of(context).colorScheme.surfaceBright,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    size: 30,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.t('processing'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  homeScaffoldKey.currentState!.closeEndDrawer();
                },
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<AugmentProvider>().augmentations.length,
              itemBuilder: (context, index) {
                return AugmentationTile(
                  augmentation: context.watch<AugmentProvider>().augmentations.reversed.toList()[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
