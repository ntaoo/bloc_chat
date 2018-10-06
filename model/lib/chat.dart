library chat;

export 'src/component/message/messages_bloc.dart';
export 'src/component/auth/auth_service.dart';

export 'src/gateway/firestore/firestore_base.dart'
    show DocumentAddRequest, DocumentUpdateRequest, Firestore;
export 'src/gateway/firestore/collections.dart'
    show RoomsCollection, MessagesCollection;
export 'src/gateway/firestore/documents/room_document.dart';
export 'src/gateway/firestore/documents/message_document.dart';

export 'src/gateway/auth.dart';
