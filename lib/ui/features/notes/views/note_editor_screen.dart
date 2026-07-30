import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/models/attachment_model.dart';
import '../../../../data/providers/repository_providers.dart';
import '../viewmodels/note_editor_viewmodel.dart';
import '../../folders/viewmodels/folders_viewmodel.dart';
import '../../tags/viewmodels/tags_viewmodel.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleController = TextEditingController();
  late QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  
  bool _isInitialized = false;
  String? _selectedFolderId;
  List<String> _selectedTagIds = [];
  bool _isPinned = false;
  bool _isFavourite = false;
  bool _isArchived = false;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _editorFocusNode.dispose();
    _titleFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initControllers(String title, String content, String? folderId, List<String> tags, bool isPinned, bool isFavourite, bool isArchived, bool isLocked) {
    if (_isInitialized) return;
    _isInitialized = true;
    _selectedFolderId = folderId;
    _selectedTagIds = List.from(tags);
    _isPinned = isPinned;
    _isFavourite = isFavourite;
    _isArchived = isArchived;
    _isLocked = isLocked;

    _titleController.text = title;
    
    if (content.isNotEmpty) {
      try {
        final doc = Document.fromJson(jsonDecode(content));
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // Fallback for raw text
        final doc = Document()..insert(0, content);
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    }
    
    // Auto-save listeners
    _quillController.document.changes.listen((event) {
      _saveNote();
    });
    _titleController.addListener(_saveNote);
  }

  Future<void> _exportNote(String format) async {
    final title = _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : 'Untitled Note';
    final safeTitle = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$safeTitle.$format');
    
    if (format == 'txt') {
      final text = _quillController.document.toPlainText();
      await file.writeAsString('$title\n\n$text');
    } else if (format == 'json') {
      final json = jsonEncode(_quillController.document.toDelta().toJson());
      await file.writeAsString(json);
    }
    
    if (mounted) {
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], text: 'Check out this note: $title'));
    }
  }

  Future<void> _attachFile() async {
    if (ref.read(noteEditorProvider(widget.noteId)).value == null) {
      await _saveNote();
    }
    
    final currentNote = ref.read(noteEditorProvider(widget.noteId)).value;
    if (currentNote == null) return;
    
    final result = await FilePicker.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      
      final appDocsDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory('${appDocsDir.path}/attachments/${currentNote.id}');
      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }
      
      final filename = result.files.single.name;
      await file.copy('${attachmentsDir.path}/$filename');
      
      final attachment = Attachment(
        id: const Uuid().v4(),
        noteId: currentNote.id,
        filename: filename,
        mimeType: result.files.single.extension ?? 'unknown',
        localPath: 'attachments/${currentNote.id}/$filename',
        size: result.files.single.size,
        createdAt: DateTime.now(),
      );
      
      await ref.read(attachmentsRepositoryProvider).addAttachment(attachment);
    }
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = jsonEncode(_quillController.document.toDelta().toJson());
    
    // Don't save if totally empty
    if (title.isEmpty && _quillController.document.toPlainText().trim().isEmpty) {
      return;
    }

    await ref.read(noteEditorProvider(widget.noteId).notifier).saveNote(
      title: title,
      content: content,
      folderId: _selectedFolderId,
      tags: _selectedTagIds,
      isPinned: _isPinned,
      isFavourite: _isFavourite,
      isArchived: _isArchived,
      isLocked: _isLocked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteEditorProvider(widget.noteId));
    final noteId = noteAsync.value?.id ?? widget.noteId;
    final attachmentsAsync = noteId != null ? ref.watch(attachmentsProvider(noteId)) : const AsyncValue.data(<Attachment>[]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveNote();
            context.pop();
          },
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final foldersAsync = ref.watch(foldersListProvider);
              return PopupMenuButton<String?>(
                icon: const Icon(Icons.folder_outlined),
                tooltip: 'Assign Folder',
                onSelected: (id) {
                  setState(() => _selectedFolderId = id);
                  _saveNote();
                },
                itemBuilder: (context) {
                  final List<PopupMenuEntry<String?>> items = [
                    const PopupMenuItem(value: null, child: Text('No Folder')),
                  ];
                  if (foldersAsync.value != null) {
                    for (final folder in foldersAsync.value!) {
                      items.add(PopupMenuItem(
                        value: folder.id,
                        child: Text(folder.name),
                      ));
                    }
                  }
                  return items;
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            tooltip: 'Attach File',
            onPressed: _attachFile,
          ),
          IconButton(
            icon: const Icon(Icons.label_outline),
            tooltip: 'Assign Tags',
            onPressed: () {
              final tagsAsync = ref.read(tagsListProvider);
              if (tagsAsync.value != null) {
                _showTagSelector(tagsAsync.value!);
              }
            },
          ),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                key: ValueKey('pin_$_isPinned'),
              ),
            ),
            tooltip: 'Pin Note',
            onPressed: () {
              setState(() => _isPinned = !_isPinned);
              _saveNote();
            },
          ),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                _isFavourite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey('fav_$_isFavourite'),
              ),
            ),
            tooltip: 'Favourite',
            onPressed: () {
              setState(() => _isFavourite = !_isFavourite);
              _saveNote();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == 'archive') {
                setState(() => _isArchived = !_isArchived);
                _saveNote();
              } else if (val == 'lock') {
                setState(() => _isLocked = !_isLocked);
                _saveNote();
              } else if (val == 'delete') {
                final currentId = noteAsync.value?.id;
                if (currentId != null) {
                  ref.read(notesRepositoryProvider).deleteNote(currentId);
                  context.pop();
                }
              } else if (val == 'export_txt') {
                _exportNote('txt');
              } else if (val == 'export_json') {
                _exportNote('json');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'archive',
                child: Text(_isArchived ? 'Unarchive' : 'Archive'),
              ),
              PopupMenuItem(
                value: 'lock',
                child: Text(_isLocked ? 'Unlock Note' : 'Lock Note'),
              ),
              if (noteAsync.value?.id != null)
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'export_txt',
                child: Text('Export to TXT'),
              ),
              const PopupMenuItem(
                value: 'export_json',
                child: Text('Export to JSON'),
              ),
            ],
          ),
        ],
      ),
      body: noteAsync.when(
        data: (note) {
          _initControllers(
            note?.title ?? '',
            note?.content ?? '',
            note?.folderId,
            note?.tags ?? [],
            note?.isPinned ?? false,
            note?.isFavourite ?? false,
            note?.isArchived ?? false,
            note?.isLocked ?? false,
          );

          Widget bodyContent = Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: QuillEditor.basic(
                    controller: _quillController,
                    focusNode: _editorFocusNode,
                    scrollController: _scrollController,
                    config: const QuillEditorConfig(
                      expands: true,
                    ),
                  ),
                ),
              ),
              if (attachmentsAsync.value != null && attachmentsAsync.value!.isNotEmpty)
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: attachmentsAsync.value!.length,
                    itemBuilder: (context, index) {
                      final att = attachmentsAsync.value![index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(att.filename, maxLines: 1, overflow: TextOverflow.ellipsis),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () async {
                             ref.read(attachmentsRepositoryProvider).deleteAttachment(att.id);
                             final appDocsDir = await getApplicationDocumentsDirectory();
                             try {
                               await File('${appDocsDir.path}/${att.localPath}').delete();
                             } catch (_) {}
                          },
                          // Make it clickable to open later
                        ),
                      );
                    },
                  ),
                ),
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: QuillSimpleToolbar(
                  controller: _quillController,
                  config: const QuillSimpleToolbarConfig(),
                ),
              ),
            ],
          );

          if (noteId != null) {
            return Hero(
              tag: 'note-hero-$noteId',
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: bodyContent,
              ),
            );
          }
          return bodyContent;
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showTagSelector(List<dynamic> allTags) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Assign Tags'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allTags.length,
                  itemBuilder: (context, index) {
                    final tag = allTags[index];
                    final isSelected = _selectedTagIds.contains(tag.id);
                    return CheckboxListTile(
                      title: Text(tag.name),
                      value: isSelected,
                      onChanged: (val) {
                        setDialogState(() {
                          if (val == true) {
                            _selectedTagIds.add(tag.id);
                          } else {
                            _selectedTagIds.remove(tag.id);
                          }
                        });
                        setState(() {});
                        _saveNote();
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
