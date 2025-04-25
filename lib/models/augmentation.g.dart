// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'augmentation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AugmentationAdapter extends TypeAdapter<Augmentation> {
  @override
  final int typeId = 1;

  @override
  Augmentation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Augmentation(
      id: fields[0] as String,
      filename: fields[1] as String,
      progress: fields[3] as double,
      entityId: fields[2] as String,
      state: fields[4] as AugmentationState,
      startTime: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Augmentation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.filename)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.startTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AugmentationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AugmentationStateAdapter extends TypeAdapter<AugmentationState> {
  @override
  final int typeId = 0;

  @override
  AugmentationState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AugmentationState.done;
      case 1:
        return AugmentationState.failed;
      case 3:
        return AugmentationState.uploading;
      default:
        return AugmentationState.done;
    }
  }

  @override
  void write(BinaryWriter writer, AugmentationState obj) {
    switch (obj) {
      case AugmentationState.done:
        writer.writeByte(0);
        break;
      case AugmentationState.failed:
        writer.writeByte(1);
        break;
      case AugmentationState.uploading:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AugmentationStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
