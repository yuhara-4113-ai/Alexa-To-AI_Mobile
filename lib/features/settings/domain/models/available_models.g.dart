// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AvailableModelsAdapter extends TypeAdapter<AvailableModels> {
  @override
  final int typeId = 2;

  @override
  AvailableModels read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AvailableModels(
      chatGPTModels: (fields[0] as List?)?.cast<String>(),
      geminiModels: (fields[1] as List?)?.cast<String>(),
      claudeModels: (fields[2] as List?)?.cast<String>(),
      lastUpdated: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AvailableModels obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.chatGPTModels)
      ..writeByte(1)
      ..write(obj.geminiModels)
      ..writeByte(2)
      ..write(obj.claudeModels)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvailableModelsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
