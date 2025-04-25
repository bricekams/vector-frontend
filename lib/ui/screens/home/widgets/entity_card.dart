import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/api/augment.dart';
import 'package:frontend/models/augmentation.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/providers/augment.dart';
import 'package:frontend/providers/home.dart';
import 'package:frontend/ui/widgets/hover_border_wrapper.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class EntityCard extends StatelessWidget {
  final Entity entity;

  const EntityCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.20833,
      height: MediaQuery.of(context).size.height * 0.20709,
      child: HoverBorderWrapper(
        hoverBorderColor: Theme.of(context).colorScheme.primary,
        onTap: () {
          context.read<HomeProvider>().setSelectedEntity(entity);
          context.read<HomeProvider>().setSelectedSideState(HomeSideState.view);
          if (!context.read<HomeProvider>().showSideBox) {
            context.read<HomeProvider>().setShowSideBox(true);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceBright,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      blurRadius: 0.5,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  image:
                      entity.image != null
                          ? DecorationImage(
                            image: NetworkImage(
                              getImageUrl(entity.image!, "entities"),
                            ),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                width: MediaQuery.of(context).size.width * 0.09,
                height: MediaQuery.of(context).size.height,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        entity.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          try {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null) {
                              PlatformFile file = result.files.single;
                              if (!context.mounted) return;
                             Augmentation augmentation = await context
                                  .read<AugmentProvider>()
                                  .addAugmentation(file.name, entity.id);
                              AugmentApi.augment(
                                entityId: entity.id,
                                file: file,
                                onProgress: (d) {
                                  context.read<AugmentProvider>().updateProgress(augmentation.id, d);
                                },
                              ).then((value) {
                                if (!context.mounted) return;
                                context.read<AugmentProvider>().updateState(
                                    augmentation.id, AugmentationState.done);
                              }).onError((err,trace){
                                if (!context.mounted) return;
                                context.read<AugmentProvider>().updateState(augmentation.id, AugmentationState.failed);
                              });
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red.shade600,

                                content: Text(
                                  context.t('wentWrong'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.file_upload_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  context.t('augment'),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
