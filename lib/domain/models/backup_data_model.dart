import 'package:freezed_annotation/freezed_annotation.dart';
import 'note_model.dart';
import 'folder_model.dart';
import 'tag_model.dart';
import 'attachment_model.dart';

part 'backup_data_model.freezed.dart';
part 'backup_data_model.g.dart';

@freezed
class BackupData with _$BackupData {
  const factory BackupData({
    required int version,
    required String exportDate,
    @Default([]) List<Note> notes,
    @Default([]) List<Folder> folders,
    @Default([]) List<Tag> tags,
    @Default([]) List<Attachment> attachments,
  }) = _BackupData;

  factory BackupData.fromJson(Map<String, dynamic> json) => _$BackupDataFromJson(json);
}
