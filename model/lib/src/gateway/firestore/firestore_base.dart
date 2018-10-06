import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

abstract class Firestore {
  Object get serverTimestamp;
  Object get ref;
}

abstract class FirestoreCollection<D extends FirestoreDocument> {
  Stream<List<D>> get onAdded;
  Stream<List<D>> get onUpdated;
  Stream<List<D>> get onDeleted;
  Future add(DocumentAddRequest<D> request);
  Future update(DocumentUpdateRequest<D> request);
  Future delete(String documentId);
}

/// Represents Firestore document.
///
/// Every sub class must add @JsonSerializable(includeIfNull: false)
/// for firestore document `update()` API that acts as "patch" (only update fields of key).
///
/// DateTime fields from Firestore are already converted to a DateTime value,
/// so that `@JsonKey(fromJson: asIs)` on a DateTime field is necessary to avoid the type mismatch error.
///
/// At `$classFromJson()` constructor,
/// when a target class field corresponding to the firestore document field is not found,
/// null value is assigned to the field.
/// Also, a firestore document's field is ignored if it does not correspond to the class's field.
@immutable
abstract class FirestoreDocument {
  FirestoreDocument(this.id, this.createdTime);

  /// Firestore document id.
  final String id;
  @JsonKey(fromJson: asIs)
  final DateTime createdTime;

  Map<String, dynamic> toJson();
}

@immutable
abstract class DocumentMutationRequest<D extends FirestoreDocument> {
  @protected
  D get document;
  @protected
  List<String> get serverTimestampFields;

  Map<String, dynamic> toJson({@required Object serverTimestamp});

  @protected
  Map<String, dynamic> applyServerTimestamp(
      Map<String, dynamic> data, Object serverTimestamp) {
    for (final field in serverTimestampFields) data[field] = serverTimestamp;
    return data;
  }
}

abstract class DocumentAddRequest<D extends FirestoreDocument>
    extends DocumentMutationRequest {}

abstract class DocumentUpdateRequest<D extends FirestoreDocument>
    extends DocumentMutationRequest {
  DocumentUpdateRequest(this.documentId);

  final String documentId;
}

Object asIs(Object object) => object;
