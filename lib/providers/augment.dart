import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/augmentation.dart';

class AugmentProvider with ChangeNotifier {
  final String boxName = 'augmentations';
  List<Augmentation> _augmentations = [];

  List<Augmentation> get augmentations => _augmentations;

  late final Box<Augmentation> box;

  Future<void> init() async {
    box = await Hive.openBox<Augmentation>(boxName);
    _augmentations =
        box.values.toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    notifyListeners();
  }

  Future<Augmentation> addAugmentation(String filename, String entityId) async {
    final augmentationId = UniqueKey().toString();

    try {
      final augmentation = Augmentation(
        id: augmentationId,
        filename: filename,
        progress: 0.0,
        entityId: entityId,
        state: AugmentationState.uploading,
        startTime: DateTime.now(),
      );
      await box.put(augmentation.id, augmentation);
      _augmentations =
          box.values.toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));
      notifyListeners();
      return augmentation;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<void> updateState(String id, AugmentationState state) async {
    final augmentation = box.get(id);
    if (augmentation != null) {
      final updated = augmentation.copyWith(state: state);
      await box.put(id, updated);
      _augmentations = box.values.toList() ..sort((a, b) => a.startTime.compareTo(b.startTime));
      notifyListeners();
    }
  }

  Future<void> updateProgress(String id, double progress) async {
    print(progress);
    final augmentation = box.get(id);
    if (augmentation != null) {
      final updated = augmentation.copyWith(progress: progress);
      await box.put(id, updated);
      var list =
          box.values.toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));
      _augmentations = list;
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    await box.clear();
    _augmentations.clear();
    notifyListeners();
  }
}
