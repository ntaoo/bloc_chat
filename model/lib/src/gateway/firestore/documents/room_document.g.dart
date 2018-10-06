// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomDocument _$RoomDocumentFromJson(Map<String, dynamic> json) {
  return RoomDocument(
      id: json['id'] as String,
      createdTime:
          json['createdTime'] == null ? null : asIs(json['createdTime']),
      name: json['name'] as String);
}

Map<String, dynamic> _$RoomDocumentToJson(RoomDocument instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('createdTime', instance.createdTime?.toIso8601String());
  writeNotNull('name', instance.name);
  return val;
}
