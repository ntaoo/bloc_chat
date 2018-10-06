import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:model/src/gateway/firestore/firestore_base.dart';

part 'room_document.g.dart';

@JsonSerializable(includeIfNull: false)
class RoomDocument extends FirestoreDocument {
  RoomDocument({String id, DateTime createdTime, this.name})
      : super(id, createdTime);

  factory RoomDocument.fromJson(Map<String, dynamic> json) =>
      _$RoomDocumentFromJson(json);

  final String name;

  Map<String, dynamic> toJson() => _$RoomDocumentToJson(this);
}

class RoomDocumentAddRequest extends DocumentAddRequest<RoomDocument> {
  RoomDocumentAddRequest({@required String name})
      : document = RoomDocument(name: name);

  @protected
  final RoomDocument document;
  @protected
  final List<String> serverTimestampFields = ['createdTime'];

  Map<String, dynamic> toJson({@required Object serverTimestamp}) =>
      applyServerTimestamp(_$RoomDocumentToJson(document), serverTimestamp);
}
