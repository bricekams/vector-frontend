import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../config/dio.dart';

class AugmentApi {
  static Future augment({
    required String entityId,
    required PlatformFile file,
    required void Function(double) onProgress,
  }) async {
    try {
      final Response response = await dio.post(
        "/langchain",
        data: FormData.fromMap({
          "entityId": entityId,
          "file": MultipartFile.fromBytes(
            file.bytes!.toList(),
            filename: file.name,
          ),
        }),
        onSendProgress: (sent, total) {
          final progress = sent / total;
          onProgress(progress);
        },
      );
      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
