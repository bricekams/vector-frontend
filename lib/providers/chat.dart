import 'package:flutter/material.dart';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/models/entity.dart';
import 'package:provider/provider.dart';

import '../api/chat.dart';
import 'home.dart';

ChatMessage fMessage = ChatMessage(id: "0", text: "text", author: Author.ai, createdAt: DateTime.now());

enum ChatState {
  loading,
  error,
  loaded,
}

enum AIState {
  thinking,
  idle
}

class ChatProvider with ChangeNotifier {
  ChatState _state = ChatState.loading;
  List<ChatMessage> _messages = [];
  AIState _aiState = AIState.idle;

  List<ChatMessage> get messages => _messages;

  ChatState get state => _state;

  AIState get aiState => _aiState;

  Future<void> init(BuildContext context) async {
    setState(ChatState.loading);
    notifyListeners();
    try {
      String entityId = context.read<HomeProvider>().selectedEntity!.id;
      setMessages(await ChatApi.getMessages(entityId));
      setState(ChatState.loaded);
      notifyListeners();
    } catch (e) {
      setState(ChatState.error);
      notifyListeners();
    }
  }

  void setState(ChatState state) {
    _state = state;
    notifyListeners();
  }

  void setMessages(List<ChatMessage> messages) {
    _messages = messages;
    if (messages.isNotEmpty) {
      _messages.insert(0, fMessage);
    } else {
      _messages.add(fMessage);
    }
    notifyListeners();
  }

  void setAIState(AIState state) {
    _aiState = state;
    notifyListeners();
  }

  void addMessage(ChatMessage message) {
    _messages.insert(1, message);
    notifyListeners();
  }
  
  void setMessageStatus(String id, ChatMessageStatus status) {
    for (var message in _messages) {
      if (message.id == id) {
        ChatMessage m = message.copyWith(status: status);
        _messages.remove(message);
        _messages.insert(1, m);
        notifyListeners();
        return;
      }
    }
  }
}