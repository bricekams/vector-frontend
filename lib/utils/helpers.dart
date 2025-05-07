import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String getImageUrl(String name, String subfolder) {
  return "${dotenv.env['BASE_API_URL']}/media/$name/$subfolder";
}

enum NotificationType {success,error,warning}

void notify(BuildContext context, NotificationType type, String text) {
  Map<NotificationType, Color> colors = {
    NotificationType.success: Colors.green,
    NotificationType.error: Colors.red,
    NotificationType.warning: Colors.amber,
  };

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colors[type],
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}