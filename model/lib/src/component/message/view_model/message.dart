import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

@Immutable('View model should be immutable')
class MessageView {
  factory MessageView(
      String id, String content, bool isEditable, DateTime createdTime) {
    return MessageView._(
        id, content, isEditable, _formatCreatedTime(createdTime));
  }

  MessageView._(this.id, this.content, this.isEditable, this.createdTime);

  final String id;
  final String content;
  final bool isEditable;
  final String createdTime;

  static String _formatCreatedTime(DateTime createdTime) {
    if (createdTime == null) return '';

    if (createdTime.day == DateTime.now().day) {
      return DateFormat.Hm().format(createdTime);
    } else {
      return DateFormat.yMMMMEEEEd().format(createdTime);
    }
  }
}
