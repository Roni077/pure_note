import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_note/data/database/app_database.dart';
import 'package:pure_note/data/repositories/notes_repository_impl.dart';
import 'package:pure_note/domain/models/note_model.dart' as domain;
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late NotesRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = NotesRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('createNote and getNoteById should work correctly', () async {
    final note = domain.Note(
      id: const Uuid().v4(),
      title: 'Test Note',
      content: 'This is a test note.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await repository.createNote(note);
    final fetchedNote = await repository.getNoteById(note.id);

    expect(fetchedNote, isNotNull);
    expect(fetchedNote!.title, 'Test Note');
    expect(fetchedNote.content, 'This is a test note.');
  });
  
  test('deleteNote moves to trash (soft delete)', () async {
    final note = domain.Note(
      id: const Uuid().v4(),
      title: 'To Be Deleted',
      content: 'Trash me',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await repository.createNote(note);
    await repository.deleteNote(note.id);
    
    final fetchedNote = await repository.getNoteById(note.id);
    expect(fetchedNote, isNotNull);
    expect(fetchedNote!.isDeleted, isTrue);
  });
}
