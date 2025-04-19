import 'package:flutter/material.dart';
import 'package:frontend/res/translations.dart';

extension BuildContextExtension on BuildContext {
  String t(String key) {
    return translations['@$key']!["fr"]!;
  }
}
