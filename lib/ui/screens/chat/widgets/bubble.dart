import 'package:flutter/material.dart';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/providers/chat.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Bubble extends StatefulWidget {
  final ChatMessage message;

  const Bubble({super.key, required this.message});

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          widget.message.author == Author.human
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
      children: [
        if (widget.message.author == Author.ai) ...[
          _getAvatar(),
          const SizedBox(width: 5),
        ],
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 200,
            maxWidth: MediaQuery.of(context).size.width * 0.4,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color:
                  widget.message.author == Author.human
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceBright,
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment:
                    widget.message.author == Author.human
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.message.text,
                    maxLines: null,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          widget.message.author == Author.human
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTime(widget.message.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              widget.message.author == Author.human
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (widget.message.author == Author.human)
                        getStatusIcon(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.message.author == Author.human) ...[
          const SizedBox(width: 5),
          _getAvatar(),
        ],
      ],
    );
  }

  Widget getStatusIcon() {
    switch (widget.message.status) {
      case ChatMessageStatus.pending:
        return SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
        );
      case ChatMessageStatus.success:
        return Icon(
          Icons.check,
          color: Theme.of(context).colorScheme.surfaceBright,
          size: 15,
        );
      case ChatMessageStatus.failed:
        return Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.onError,
          size: 15,
        );
    }
  }

  _getForegroundColor() {
    switch (widget.message.author) {
      case Author.human:
        return Theme.of(context).colorScheme.surfaceBright;
      case Author.ai:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  _getAvatar() {
    return Container(
      width: 23,
      height: 23,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(3),
        color:
            widget.message.author == Author.human
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceBright,
      ),
      child: Icon(
        widget.message.author == Author.human
            ? Icons.person
            : Icons.smart_toy_rounded,
        color: _getForegroundColor(),
        size: 15,
      ),
    );
  }
}

String getTime(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

class ThinkingBubble extends StatelessWidget {
  const ThinkingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    switch (context.watch<ChatProvider>().aiState) {
      case AIState.thinking:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 23,
              height: 23,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).colorScheme.surfaceBright,
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 15,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${context.t('thinking')}...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        );
      case AIState.idle:
        return SizedBox.shrink();
    }
  }
}
