// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BackupData _$BackupDataFromJson(Map<String, dynamic> json) {
  return _BackupData.fromJson(json);
}

/// @nodoc
mixin _$BackupData {
  int get version => throw _privateConstructorUsedError;
  String get exportDate => throw _privateConstructorUsedError;
  List<Note> get notes => throw _privateConstructorUsedError;
  List<Folder> get folders => throw _privateConstructorUsedError;
  List<Tag> get tags => throw _privateConstructorUsedError;
  List<Attachment> get attachments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BackupDataCopyWith<BackupData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupDataCopyWith<$Res> {
  factory $BackupDataCopyWith(
          BackupData value, $Res Function(BackupData) then) =
      _$BackupDataCopyWithImpl<$Res, BackupData>;
  @useResult
  $Res call(
      {int version,
      String exportDate,
      List<Note> notes,
      List<Folder> folders,
      List<Tag> tags,
      List<Attachment> attachments});
}

/// @nodoc
class _$BackupDataCopyWithImpl<$Res, $Val extends BackupData>
    implements $BackupDataCopyWith<$Res> {
  _$BackupDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? exportDate = null,
    Object? notes = null,
    Object? folders = null,
    Object? tags = null,
    Object? attachments = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      exportDate: null == exportDate
          ? _value.exportDate
          : exportDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      folders: null == folders
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<Folder>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupDataImplCopyWith<$Res>
    implements $BackupDataCopyWith<$Res> {
  factory _$$BackupDataImplCopyWith(
          _$BackupDataImpl value, $Res Function(_$BackupDataImpl) then) =
      __$$BackupDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int version,
      String exportDate,
      List<Note> notes,
      List<Folder> folders,
      List<Tag> tags,
      List<Attachment> attachments});
}

/// @nodoc
class __$$BackupDataImplCopyWithImpl<$Res>
    extends _$BackupDataCopyWithImpl<$Res, _$BackupDataImpl>
    implements _$$BackupDataImplCopyWith<$Res> {
  __$$BackupDataImplCopyWithImpl(
      _$BackupDataImpl _value, $Res Function(_$BackupDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? exportDate = null,
    Object? notes = null,
    Object? folders = null,
    Object? tags = null,
    Object? attachments = null,
  }) {
    return _then(_$BackupDataImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      exportDate: null == exportDate
          ? _value.exportDate
          : exportDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      folders: null == folders
          ? _value._folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<Folder>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupDataImpl implements _BackupData {
  const _$BackupDataImpl(
      {required this.version,
      required this.exportDate,
      final List<Note> notes = const [],
      final List<Folder> folders = const [],
      final List<Tag> tags = const [],
      final List<Attachment> attachments = const []})
      : _notes = notes,
        _folders = folders,
        _tags = tags,
        _attachments = attachments;

  factory _$BackupDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupDataImplFromJson(json);

  @override
  final int version;
  @override
  final String exportDate;
  final List<Note> _notes;
  @override
  @JsonKey()
  List<Note> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  final List<Folder> _folders;
  @override
  @JsonKey()
  List<Folder> get folders {
    if (_folders is EqualUnmodifiableListView) return _folders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  final List<Tag> _tags;
  @override
  @JsonKey()
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<Attachment> _attachments;
  @override
  @JsonKey()
  List<Attachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  String toString() {
    return 'BackupData(version: $version, exportDate: $exportDate, notes: $notes, folders: $folders, tags: $tags, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupDataImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.exportDate, exportDate) ||
                other.exportDate == exportDate) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            const DeepCollectionEquality().equals(other._folders, _folders) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      version,
      exportDate,
      const DeepCollectionEquality().hash(_notes),
      const DeepCollectionEquality().hash(_folders),
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_attachments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupDataImplCopyWith<_$BackupDataImpl> get copyWith =>
      __$$BackupDataImplCopyWithImpl<_$BackupDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupDataImplToJson(
      this,
    );
  }
}

abstract class _BackupData implements BackupData {
  const factory _BackupData(
      {required final int version,
      required final String exportDate,
      final List<Note> notes,
      final List<Folder> folders,
      final List<Tag> tags,
      final List<Attachment> attachments}) = _$BackupDataImpl;

  factory _BackupData.fromJson(Map<String, dynamic> json) =
      _$BackupDataImpl.fromJson;

  @override
  int get version;
  @override
  String get exportDate;
  @override
  List<Note> get notes;
  @override
  List<Folder> get folders;
  @override
  List<Tag> get tags;
  @override
  List<Attachment> get attachments;
  @override
  @JsonKey(ignore: true)
  _$$BackupDataImplCopyWith<_$BackupDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
