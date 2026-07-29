// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BackupDataImpl _$$BackupDataImplFromJson(Map<String, dynamic> json) =>
    _$BackupDataImpl(
      version: (json['version'] as num).toInt(),
      exportDate: json['exportDate'] as String,
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => Note.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      folders: (json['folders'] as List<dynamic>?)
              ?.map((e) => Folder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BackupDataImplToJson(_$BackupDataImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'exportDate': instance.exportDate,
      'notes': instance.notes,
      'folders': instance.folders,
      'tags': instance.tags,
      'attachments': instance.attachments,
    };
