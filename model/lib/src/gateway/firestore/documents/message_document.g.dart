// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDocument _$MessageDocumentFromJson(Map<String, dynamic> json) {
  return MessageDocument(
      id: json['id'] as String,
      createdTime:
          json['createdTime'] == null ? null : asIs(json['createdTime']),
      uid: json['uid'] as String,
      content: json['content'] as String,
      contentEditedTime: json['contentEditedTime'] == null
          ? null
          : asIs(json['contentEditedTime']));
}

Map<String, dynamic> _$MessageDocumentToJson(MessageDocument instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('createdTime', instance.createdTime?.toIso8601String());
  writeNotNull('uid', instance.uid);
  writeNotNull('content', instance.content);
  writeNotNull(
      'contentEditedTime', instance.contentEditedTime?.toIso8601String());
  return val;
}
