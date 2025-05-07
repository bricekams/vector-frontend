import 'package:flutter/material.dart';
import 'package:frontend/api/chat.dart';
import 'package:frontend/config/ws.dart';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/providers/chat.dart';
import 'package:frontend/providers/chat_entities.dart';
import 'package:frontend/providers/home.dart';
import 'package:frontend/ui/screens/chat/widgets/bubble.dart';
import 'package:frontend/ui/widgets/error_widget.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _controller = TextEditingController();

  late ChatProvider _chatProvider;

  late Function(dynamic) _onStartThinking;
  late Function(dynamic) _onErrorThinking;
  late Function(dynamic) _onEndThinking;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = context.read<ChatProvider>();
  }

  @override
  void initState() {
    super.initState();

    _onStartThinking = (questionId) {
      if (!mounted) return;
      _chatProvider.setMessageStatus(
        questionId.toString(),
        ChatMessageStatus.success,
      );
      _chatProvider.setAIState(AIState.thinking);
    };

    _onErrorThinking = (questionId) {
      if (!mounted) return;
      _chatProvider.setMessageStatus(
        questionId.toString(),
        ChatMessageStatus.failed,
      );
    };

    _onEndThinking = (response) {
      if (!mounted) return;
      _chatProvider.setAIState(AIState.idle);
      DateTime now = DateTime.now();
      ChatMessage message = ChatMessage(
        id: now.toIso8601String(),
        text: response.toString(),
        author: Author.ai,
        createdAt: now,
        status: ChatMessageStatus.success,
      );
      _chatProvider.addMessage(message);
    };

    WSService.socket?.off("start-thinking", _onStartThinking);
    WSService.socket?.off("error-thinking", _onErrorThinking);
    WSService.socket?.off("end-thinking", _onEndThinking);

    WSService.socket!.on("start-thinking", _onStartThinking);
    WSService.socket!.on("error-thinking", _onErrorThinking);
    WSService.socket!.on("end-thinking", _onEndThinking);
  }

  @override
  void dispose() {
    WSService.socket?.off("start-thinking", _onStartThinking);
    WSService.socket?.off("error-thinking", _onErrorThinking);
    WSService.socket?.off("end-thinking", _onEndThinking);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: _buildView(),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    ChatMessage message = ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: _controller.text.trim(),
      author: Author.human,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.pending,
    );

    ChatApi.sendMessage(message, [
      context.read<HomeProvider>().selectedEntity!.id,
      ...context.read<ChatEntitiesProvider>().selectedEntities!.map(
        (e) => e.id,
      ),
    ]);
    _controller.clear();
    context.read<ChatProvider>().addMessage(message);
    setState(() {});
  }

  _buildView() {
    switch (context.watch<ChatProvider>().state) {
      case ChatState.loading:
        return Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Theme.of(context).colorScheme.primary,
            size: 100,
          ),
        );
      case ChatState.error:
        return CustomErrorWidget(
          onRetry: () {
            context.read<ChatProvider>().init(context);
          },
        );
      case ChatState.loaded:
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.separated(
                reverse: true,
                itemCount: context.watch<ChatProvider>().messages.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ThinkingBubble();
                  }
                  final m = context.watch<ChatProvider>().messages[index];
                  return Bubble(message: m);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: context.t('typeYourMessage'),
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _sendMessage,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4,
                      ),
                    ),
                    child: Container(
                      width: 50,
                      height: 40.6,
                      padding: EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.primary,
                        border: Border.all(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryFixedVariant,
                          width: 3,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.5),
                        child: Icon(
                          Icons.send_rounded,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryFixedVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }
}
