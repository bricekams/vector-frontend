import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/entity.dart';
import '../config/dio.dart';

class EntityApi {
  static Future<Entity> create(FormData data) async {
    try {
      Response response = await dio.post("/entities", data: data);
      print("response $response");
      Entity entity = Entity.fromJson(response.data);
      return entity;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  static Future<List<Entity>> getAll() async {
    try {
      Response response = await dio.get("/entities");
      List<Entity> entities = (response.data as List)
          .map((e) => Entity.fromJson(e as Map<String, dynamic>))
          .toList();
      return entities;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  static Future<Entity?> get(String id) async {
    try {
      Response response = await dio.get("/entities/$id");
      Entity? entity = Entity.fromJson(response.data);
      return entity;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      await dio.delete("/entities/$id");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  static Future<Entity> update(String id, Map<String, dynamic> data) async {
    try {
      Response response = await dio.put("/entities/$id", data: data);
      Entity entity = Entity.fromJson(response.data);
      return entity;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
