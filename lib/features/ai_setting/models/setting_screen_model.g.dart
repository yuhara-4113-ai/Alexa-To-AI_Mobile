// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_screen_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingScreenModelAdapter extends TypeAdapter<SettingScreenModel> {
  @override
  final int typeId = 0;

  @override
  SettingScreenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingScreenModel()
      ..aiTone = fields[0] as String
      ..isSaved = fields[1] as bool
      ..selectedType = fields[2] as String
      ..aiModelsPerType = (fields[3] as Map).cast<String, AIModel>()
      ..userId = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, SettingScreenModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.aiTone)
      ..writeByte(1)
      ..write(obj.isSaved)
      ..writeByte(2)
      ..write(obj.selectedType)
      ..writeByte(3)
      ..write(obj.aiModelsPerType)
      ..writeByte(4)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingScreenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
