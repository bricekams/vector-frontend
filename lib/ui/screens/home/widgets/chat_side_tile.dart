import 'package:flutter/material.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/providers/chat_entities.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:provider/provider.dart';

class ChatSideTile extends StatelessWidget {
  final Entity entity;
  const ChatSideTile({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
              headers: {'bypass-tunnel-reminder': 'true'},
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        entity.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        context.t(entity.type.name),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          context.read<ChatEntitiesProvider>().addEntity(
            entity,
          );
          context.read<ChatEntitiesProvider>().setSearch("");
        },
        icon: Checkbox(
          shape: CircleBorder(),

          value: context
              .watch<ChatEntitiesProvider>()
              .isSelected(entity),
          onChanged: (value) {
            if (value == null) return;
            if (value) {
              context
                  .read<ChatEntitiesProvider>()
                  .addEntity(entity);
            } else {
              context
                  .read<ChatEntitiesProvider>()
                  .removeEntity(entity);
            }
          },
        ),
      ),
    );
  }
}
