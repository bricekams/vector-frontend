import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/augment.dart';
import 'package:frontend/api/entity.dart';
import 'package:frontend/config/routes.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/providers/home.dart';
import 'package:frontend/ui/screens/loader.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'delete_entity_dialog.dart';

class SummaryEntityWidget extends StatefulWidget {
  const SummaryEntityWidget({super.key});

  @override
  State<SummaryEntityWidget> createState() => _SummaryEntityWidgetState();
}

class _SummaryEntityWidgetState extends State<SummaryEntityWidget> {
  bool deleting = false;
  bool downloading = false;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.10416,
                  height: MediaQuery.of(context).size.height * 0.20709,
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
                        headers: {'bypass-tunnel-reminder': 'true'},
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: context.t('uploads'),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  ' (${context.watch<HomeProvider>().selectedEntity?.uploadsCount})',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            Row(
              children: [
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
                    width: 50,
                    height: 38.5,
                    padding: EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color:
                          Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    ),
                    child: Center(
                      child:Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      context.push(AppRoutes.chat, extra: selectedEntity);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.onSecondaryFixedVariant,
                      ),
                      child: Center(
                        child: Text(
                          context.t('discuss'),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteEntityDialog(entity: selectedEntity);
                      },
                    );
                    if (!confirm) return;
                    setState(() => deleting = true);
                    EntityApi.delete(selectedEntity.id).then((value) {
                      if (!context.mounted) return;
                      setState(() => deleting = false);
                      context.read<HomeProvider>().setShowSideBox(false);
                      context.read<HomeProvider>().removeEntity(selectedEntity);
                      notify(context, NotificationType.success, context.t('entityDeleted'));
                    }).onError((err,trace){
                      if (!context.mounted) return;
                      setState(() => deleting = false);
                      notify(context, NotificationType.error, context.t('failedEntityDeletion'));
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 38.5,
                    padding: EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.red,
                    ),
                    child: Center(
                      child:
                          deleting
                              ? SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: Colors.white,
                                ),
                              )
                              : Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
