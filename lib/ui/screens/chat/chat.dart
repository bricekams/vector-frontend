import 'package:flutter/material.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/providers/chat.dart';
import 'package:frontend/providers/chat_entities.dart';
import 'package:frontend/providers/home.dart';
import 'package:frontend/ui/screens/chat/widgets/chat_view.dart';
import 'package:frontend/ui/screens/home/widgets/chat_side_tile.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Entity entity;

  const ChatScreen({super.key, required this.entity});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatProvider>().init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.22,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.surfaceBright,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.15293,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(
                              getImageUrl(widget.entity.image!, "entities"),
                              headers: {'bypass-tunnel-reminder': 'true'},
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.entity.name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                context.t(widget.entity.type.name),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    onChanged: (value) {
                      context.read<ChatEntitiesProvider>().setSearch(value);
                    },
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15),
                      hintText: context.t('filter'),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          context
                              .watch<HomeProvider>()
                              .entities
                              ?.where(
                                (e) =>
                                    e.id != widget.entity.id &&
                                    e.name.toLowerCase().contains(
                                      context
                                          .watch<ChatEntitiesProvider>()
                                          .search.toLowerCase(),
                                    ),
                              )
                              .length ??
                          0,
                      itemBuilder: (context, index) {
                        final chatEntitiesProvider =
                            context.watch<ChatEntitiesProvider>();
                        final entities =
                            (context
                                    .watch<HomeProvider>()
                                    .entities
                                    ?.where(
                                      (e) =>
                                          e.id != widget.entity.id &&
                                          e.name.toLowerCase().contains(
                                            chatEntitiesProvider.search.toLowerCase(),
                                          ),
                                    )
                                    .toList()
                                  ?..sort((a, b) {
                                    final aSelected = chatEntitiesProvider
                                        .isSelected(a);
                                    final bSelected = chatEntitiesProvider
                                        .isSelected(b);

                                    if (aSelected && !bSelected) {
                                      return -1;
                                    }
                                    if (!aSelected && bSelected) {
                                      return 1;
                                    }

                                    return a.name.compareTo(b.name);
                                  }))!
                                .toList();

                        final entity = entities[index];
                        return ChatSideTile(entity: entity);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/chat-bg.png'),
                  fit: BoxFit.contain,
                  opacity: 0.05,
                ),
              ),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ChatView(),
            ),
          ),
        ],
      ),
    );
  }
}
