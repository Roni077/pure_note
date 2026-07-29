// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      id: json['id'] as String,
      noteId: json['noteId'] as String,
      filename: json['filename'] as String,
      mimeType: json['mimeType'] as String,
      localPath: json['localPath'] as String,
      size: (json['size'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'filename': instance.filename,
      'mimeType': instance.mimeType,
      'localPath': instance.localPath,
      'size': instance.size,
      'createdAt': instance.createdAt.toIso8601String(),
    };
