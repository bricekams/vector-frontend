import 'package:hive_flutter/hive_flutter.dart';

part 'augmentation.g.dart';

@HiveType(typeId: 0)
enum AugmentationState {
  @HiveField(0)
  done,
  @HiveField(1)
  failed,
  @HiveField(3)
  uploading,
}

@HiveType(typeId: 1)
class Augmentation {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String filename;

  @HiveField(2)
  final String entityId;

  @HiveField(3)
  final double progress;

  @HiveField(4)
  final AugmentationState state;

  @HiveField(5)
  final DateTime startTime;

  const Augmentation({
    required this.id,
    required this.filename,
    required this.progress,
    required this.entityId,
    required this.state,
    required this.startTime,
  });

  factory Augmentation.fromJson(Map<String, dynamic> json) => Augmentation(
    id: json['id'],
    filename: json['filename'],
    entityId: json['entity'],
    progress: json['progress'],
    state: AugmentationState.values.firstWhere((e) => e.name == json['state']),
    startTime: DateTime.parse(json['startTime']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'filename': filename,
    'entityId': entityId,
    'progress': progress,
    'state': state.name,
    'startTime': startTime.toIso8601String(),
  };

  Augmentation copyWith({
    String? id,
    String? filename,
    String? entityId,
    double? progress,
    AugmentationState? state,
  }) {
    return Augmentation(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      entityId: entityId ?? this.entityId,
      progress: progress ?? this.progress,
      state: state ?? this.state,
      startTime: startTime
    );
  }

  static registerAdapters() {
    Hive.registerAdapter(AugmentationStateAdapter());
    Hive.registerAdapter(AugmentationAdapter());
  }
}
