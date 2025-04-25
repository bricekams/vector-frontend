import 'package:flutter/material.dart';
import 'package:frontend/models/augmentation.dart';
import 'package:frontend/providers/augment.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _HomeAppBarState extends State<HomeAppBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(color: Theme
          .of(context)
          .colorScheme
          .primary),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Vector 1.0',
          style: Theme
              .of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .colorScheme
                .onPrimary,
          ),
        ),
        subtitle: Text(
          context.t('moto'),
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .colorScheme
                .onPrimary,
          ),
        ),
        trailing:
        context
            .watch<AugmentProvider>()
            .augmentations
            .isNotEmpty
            ? InkWell(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: Theme
                        .of(context)
                        .colorScheme
                        .surfaceBright,
                  ),
                  child: Center(
                    child: Icon(Icons.file_upload_outlined),
                  ),
                ),
                _buildCounterZone(),
              ],
            ),
          ),
        )
            : null,
      ),
    );
  }

  _buildCounterZone() {
    bool hasAugmentations = context
        .watch<AugmentProvider>()
        .augmentations
        .isNotEmpty;
    if (!hasAugmentations) {
      return null;
    }
    Augmentation? lastAugmentation = context
        .watch<AugmentProvider>()
        .augmentations.last;
    if (lastAugmentation.state == AugmentationState.uploading) {
      return Align(
        alignment: Alignment(1.5, -1.5),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
            color: Theme
                .of(context)
                .colorScheme
                .surfaceBright,
          ),
          child: Center(
            child: Text(
              context
                  .read<AugmentProvider>()
                  .augmentations
                  .length
                  .toString(),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    if (lastAugmentation.state == AugmentationState.failed) {
      return Align(
        alignment: Alignment(1.5, -1.5),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
            color: Theme
                .of(context)
                .colorScheme
                .surfaceBright,),
          child: Center(
            child: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    if (lastAugmentation.state == AugmentationState.done) {
      return Align(
        alignment: Alignment(1.5, -1.5),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
            color: Theme
                .of(context)
                .colorScheme
                .surfaceBright,
          ),
          child: Center(
            child: Icon(
              Icons.done,
              color: Colors.green,
            ),
          ),
        ),
      );
    }
  }
}