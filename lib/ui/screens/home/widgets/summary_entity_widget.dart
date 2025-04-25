import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/providers/home.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:provider/provider.dart';

class SummaryEntityWidget extends StatelessWidget {
  const SummaryEntityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedEntity = context.watch<HomeProvider>().selectedEntity;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.77,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.10416,
              height: MediaQuery.of(context).size.height * 0.20709,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    blurRadius: 0.5,
                    spreadRadius: 1,
                    offset: Offset(0, 0),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(
                    getImageUrl(selectedEntity!.image!, "entities"),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              selectedEntity.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedEntity.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                context.read<HomeProvider>().setSelectedSideState(
                  HomeSideState.edit,
                );
                if (!context.read<HomeProvider>().showSideBox) {
                  context.read<HomeProvider>().setShowSideBox(true);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
                ),
                child: Center(
                  child: Text(
                    context.t('edit'),
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
      ),
    );
  }
}
