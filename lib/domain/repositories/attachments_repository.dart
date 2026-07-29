import '../models/attachment_model.dart';

abstract class AttachmentsRepository {
  Stream<List<Attachment>> watchAttachments(String noteId);
  Future<void> addAttachment(Attachment attachment);
  Future<void> deleteAttachment(String id);
}
