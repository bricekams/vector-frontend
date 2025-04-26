import 'package:flutter/cupertino.dart';
import 'package:frontend/api/entity.dart';

import '../models/entity.dart';

enum HomeProviderState { loading, loaded, error }
enum HomeSideState { create, edit, view, }

class HomeProvider with ChangeNotifier {

  Entity? selectedEntity;

  List<Entity>? _entities;
  String search = "";
  String? selectedEntityType;
  bool showSideBox = false;

  HomeSideState selectedSideState = HomeSideState.view;

  List<Entity>? get entities =>
      _entities?.reversed.toList().where((e) {
        final inSearch = (e.name.toLowerCase().contains(search.toLowerCase()) ||
                e.description.toLowerCase().contains(search.toLowerCase()));

        if (selectedEntityType == null) {
          return inSearch;
        }

        return inSearch && e.type.name == selectedEntityType;
      }).toList();

  HomeProviderState state = HomeProviderState.loading;

  Future<void> init() async {
    state = HomeProviderState.loading;
    notifyListeners();
    try {
      setEntities(await EntityApi.getAll());
      state = HomeProviderState.loaded;
      notifyListeners();
    } catch (e) {
      state = HomeProviderState.error;
      notifyListeners();
    }
  }

  void setEntities(List<Entity> entities) {
    _entities = entities;
  }

  void addEntity(Entity entity) {
    _entities!.add(entity);
    notifyListeners();
  }

  void removeEntity(Entity entity) {
    _entities!.removeWhere((e) => e.id == entity.id);
    notifyListeners();
  }

  void setSearch(String search) {
    this.search = search.replaceAll(RegExp(r'\s+'), ' ').trimLeft().trimRight();
    notifyListeners();
  }

  void setSelectedEntityType(String? selectedEntityType) {
    this.selectedEntityType = selectedEntityType;
    notifyListeners();
  }

  void setSelectedSideState(HomeSideState selectedSideState) {
    this.selectedSideState = selectedSideState;
    notifyListeners();
  }

  void setShowSideBox(bool showSideBox) {
    this.showSideBox = showSideBox;
    notifyListeners();
  }

  void setSelectedEntity(Entity? selectedEntity) {
    this.selectedEntity = selectedEntity;
    notifyListeners();
  }

  void updateEntity(Entity entity) {
    _entities!.removeWhere((e) => e.id == entity.id);
    _entities!.add(entity);
    notifyListeners();
  }

  void incrementUploadsCount(Entity entity) {
    final updatedEntity = entity.copyWith(uploadsCount: entity.uploadsCount + 1);
    _entities!.removeWhere((e) => e.id == entity.id);
    _entities!.add(updatedEntity);
    notifyListeners();
  }
}
