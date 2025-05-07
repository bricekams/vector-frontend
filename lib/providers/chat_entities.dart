import 'package:flutter/cupertino.dart';
import 'package:frontend/models/entity.dart';

class ChatEntitiesProvider with ChangeNotifier {
  final List<Entity> _selectedEntities = [];
  List<Entity>? get selectedEntities => _selectedEntities;

  String search = "";

  void addEntity(Entity entity) {
    _selectedEntities.add(entity);
    notifyListeners();
  }

  void removeEntity(Entity entity) {
    _selectedEntities.removeWhere((e) => e.id == entity.id);
    notifyListeners();
  }

  bool isSelected(Entity entity) {
    return _selectedEntities.any((e) => e.id == entity.id);
  }

  void setSearch(String search) {
    this.search = search.replaceAll(RegExp(r'\s+'), ' ').trimLeft().trimRight();
    notifyListeners();
  }
}
