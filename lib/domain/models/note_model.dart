import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    @Default('') String title,
    @Default('') String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? folderId,
    @Default(false) bool isPinned,
    @Default(false) bool isFavourite,
    @Default(false) bool isArchived,
    @Default(false) bool isLocked,
    @Default(false) bool isEncrypted,
    @Default(false) bool isDeleted,
    @Default('text') String noteType,
    DateTime? reminder,
    String? color,
    @Default([]) List<String> tags,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
