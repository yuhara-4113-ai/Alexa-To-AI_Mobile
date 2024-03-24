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
      ..aiName = fields[0] as String
      ..aiPersonality = fields[1] as String
      ..aiTone = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, SettingScreenModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.aiName)
      ..writeByte(1)
      ..write(obj.aiPersonality)
      ..writeByte(2)
      ..write(obj.aiTone);
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
