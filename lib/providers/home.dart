import 'package:flutter/cupertino.dart';

import '../models/entity.dart';


enum HomeProviderState { loading, loaded, error }

class HomeProvider with ChangeNotifier {
  List<Entity>? entities;
  HomeProviderState state = HomeProviderState.loading;

  void setEntities(List<Entity> entities) {
    this.entities = entities;
    notifyListeners();
  }

  void addEntity(Entity entity) {
    entities!.insert(0, entity);
    notifyListeners();
  }
}