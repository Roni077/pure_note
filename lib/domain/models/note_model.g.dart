// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      folderId: json['folderId'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      isFavourite: json['isFavourite'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      noteType: json['noteType'] as String? ?? 'text',
      reminder: json['reminder'] == null
          ? null
          : DateTime.parse(json['reminder'] as String),
      color: json['color'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'folderId': instance.folderId,
      'isPinned': instance.isPinned,
      'isFavourite': instance.isFavourite,
      'isArchived': instance.isArchived,
      'isLocked': instance.isLocked,
      'isEncrypted': instance.isEncrypted,
      'isDeleted': instance.isDeleted,
      'noteType': instance.noteType,
      'reminder': instance.reminder?.toIso8601String(),
      'color': instance.color,
      'tags': instance.tags,
    };
