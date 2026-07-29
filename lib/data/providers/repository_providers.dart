import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../domain/repositories/folders_repository.dart';
import '../../domain/repositories/tags_repository.dart';
import '../../domain/repositories/attachments_repository.dart';
import '../../domain/services/backup_service.dart';
import '../../domain/services/auth_service.dart';
import '../repositories/notes_repository_impl.dart';
import '../repositories/folders_repository_impl.dart';
import '../repositories/tags_repository_impl.dart';
import '../repositories/attachments_repository_impl.dart';
import '../services/backup_service_impl.dart';
import '../services/auth_service_impl.dart';
import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepositoryImpl(ref.watch(databaseProvider));
});

final foldersRepositoryProvider = Provider<FoldersRepository>((ref) {
  return FoldersRepositoryImpl(ref.watch(databaseProvider));
});

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return TagsRepositoryImpl(ref.watch(databaseProvider));
});

final attachmentsRepositoryProvider = Provider<AttachmentsRepository>((ref) {
  return AttachmentsRepositoryImpl(ref.watch(databaseProvider));
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupServiceImpl(ref.watch(databaseProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl();
});
