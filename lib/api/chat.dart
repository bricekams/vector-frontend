import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/config/dio.dart';
import 'package:frontend/config/ws.dart';
import 'package:frontend/models/chat_message.dart';

class ChatApi {
  static Future<void> sendMessage(ChatMessage message, List<String> entitiesIds) async {
    WSService.socket!.emit('message', {
      "entitiesIds": entitiesIds.map((e)=>'"$e"').toList(),
      "question": message.text,
      "questionId": message.id,
    });
  }

  static Future<List<ChatMessage>> getMessages(String entityId) async {
    try {
      final Response response = await dio.get(
        '/entities/$entityId',
      );
      final data = response.data["messages"];
      final List<ChatMessage> messages = (data as List).map((e) => ChatMessage.fromJson(e)).toList();
      return messages;
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}