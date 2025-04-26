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

  @HiveField(6)
  final DateTime updatedAt;

  const Augmentation({
    required this.id,
    required this.filename,
    required this.progress,
    required this.entityId,
    required this.state,
    required this.startTime,
    required this.updatedAt,
  });

  factory Augmentation.fromJson(Map<String, dynamic> json) => Augmentation(
    id: json['id'],
    filename: json['filename'],
    entityId: json['entity'],
    progress: json['progress'],
    state: AugmentationState.values.firstWhere((e) => e.name == json['state']),
    startTime: DateTime.parse(json['startTime']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'filename': filename,
    'entityId': entityId,
    'progress': progress,
    'state': state.name,
    'startTime': startTime.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Augmentation copyWith({
    String? id,
    String? filename,
    String? entityId,
    double? progress,
    AugmentationState? state,
    DateTime? updatedAt,
  }) {
    return Augmentation(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      entityId: entityId ?? this.entityId,
      progress: progress ?? this.progress,
      state: state ?? this.state,
      startTime: startTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static registerAdapters() {
    Hive.registerAdapter(AugmentationStateAdapter());
    Hive.registerAdapter(AugmentationAdapter());
  }
}
