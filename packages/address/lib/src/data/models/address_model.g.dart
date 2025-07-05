// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressModelAdapter extends TypeAdapter<AddressModel> {
  @override
  final int typeId = 1;

  @override
  AddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressModel(
      id: fields[0] as String,
      icon: fields[1] as String,
      label: fields[2] as String?,
      buildingName: fields[3] as String?,
      apartmentSuite: fields[4] as String?,
      entryCode: fields[5] as String?,
      instructions: fields[6] as String?,
      description: fields[7] as String,
      mainText: fields[8] as String,
      secondaryText: fields[9] as String,
      lat: fields[10] as double,
      lng: fields[11] as double,
      origin: fields[12] as AddressOriginTypeHive,
      updatedAt: fields[13] as DateTime,
      createdAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AddressModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.buildingName)
      ..writeByte(4)
      ..write(obj.apartmentSuite)
      ..writeByte(5)
      ..write(obj.entryCode)
      ..writeByte(6)
      ..write(obj.instructions)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.mainText)
      ..writeByte(9)
      ..write(obj.secondaryText)
      ..writeByte(10)
      ..write(obj.lat)
      ..writeByte(11)
      ..write(obj.lng)
      ..writeByte(12)
      ..write(obj.origin)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddressOriginTypeHiveAdapter extends TypeAdapter<AddressOriginTypeHive> {
  @override
  final int typeId = 0;

  @override
  AddressOriginTypeHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AddressOriginTypeHive.nearby;
      case 1:
        return AddressOriginTypeHive.searched;
      case 2:
        return AddressOriginTypeHive.labelled;
      default:
        return AddressOriginTypeHive.nearby;
    }
  }

  @override
  void write(BinaryWriter writer, AddressOriginTypeHive obj) {
    switch (obj) {
      case AddressOriginTypeHive.nearby:
        writer.writeByte(0);
        break;
      case AddressOriginTypeHive.searched:
        writer.writeByte(1);
        break;
      case AddressOriginTypeHive.labelled:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressOriginTypeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
