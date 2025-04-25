import 'package:flutter/material.dart';
import 'package:frontend/models/augmentation.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/providers/home.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:provider/provider.dart';

class AugmentationTile extends StatefulWidget {
  final Augmentation augmentation;
  const AugmentationTile({super.key, required this.augmentation});

  @override
  State<AugmentationTile> createState() => _AugmentationTileState();
}

class _AugmentationTileState extends State<AugmentationTile> {
  @override
  Widget build(BuildContext context) {
    final Entity entity = context.read<HomeProvider>().entities!.firstWhere((e) => e.id == widget.augmentation.entityId);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
          image: DecorationImage(
            image: NetworkImage(
              getImageUrl(entity.image!, "entities"),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(widget.augmentation.filename),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildSubtitle(widget.augmentation.state)),
          const SizedBox(width: 10),
          Text('${widget.augmentation.startTime.hour.toString().padLeft(2, '0')}:${widget.augmentation.startTime.minute.toString().padLeft(2, '0')}'),
        ],
      ),
    );
  }

  _buildSubtitle(AugmentationState state) {
    switch (state) {
      case AugmentationState.done:
        return Text(context.t("success"), style: TextStyle(color: Colors.green));
      case AugmentationState.failed:
        return Text(context.t("failed"), style: TextStyle(color: Colors.red));
      case AugmentationState.uploading:
        return LinearProgressIndicator(
          value: widget.augmentation.progress,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        );
    }
  }
}
