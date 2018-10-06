import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:model/src/gateway/firestore/firestore_base.dart';

part 'message_document.g.dart';

@JsonSerializable(includeIfNull: false)
class MessageDocument extends FirestoreDocument {
  MessageDocument({
    String id,
    DateTime createdTime,
    this.uid,
    this.content,
    this.contentEditedTime,
  }) : super(id, createdTime);

  factory MessageDocument.fromJson(Map<String, dynamic> json) =>
      _$MessageDocumentFromJson(json);

  final String uid;
  final String content;
  @JsonKey(fromJson: asIs)
  final DateTime contentEditedTime;

  Map<String, dynamic> toJson() => _$MessageDocumentToJson(this);
}

class MessageDocumentAddRequest extends DocumentAddRequest<MessageDocument> {
  MessageDocumentAddRequest({@required String uid, @required String content})
      : document = MessageDocument(uid: uid, content: content);

  @protected
  final MessageDocument document;
  @protected
  final List<String> serverTimestampFields = ['createdTime'];

  Map<String, dynamic> toJson({@required Object serverTimestamp}) {
    // Explicitly set null to contentEditedTime.
    final data = _$MessageDocumentToJson(document)
      ..['contentEditedTime'] = null;
    return applyServerTimestamp(data, serverTimestamp);
  }
}

class MessageDocumentContentUpdateRequest
    extends DocumentUpdateRequest<MessageDocument> {
  MessageDocumentContentUpdateRequest(String documentId,
      {@required String content})
      : document = MessageDocument(content: content),
        super(documentId);

  @protected
  final MessageDocument document;
  @protected
  final List<String> serverTimestampFields = ['contentEditedTime'];

  Map<String, dynamic> toJson({@required Object serverTimestamp}) =>
      applyServerTimestamp(_$MessageDocumentToJson(document), serverTimestamp);
}
