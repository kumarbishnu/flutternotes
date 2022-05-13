import 'package:flutter/material.dart';

import '../../services/crud/notes_service.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onTap;
  final NoteCallback onDeleteNote;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onTap,
    required this.onDeleteNote
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          child: ListTile(
            title: Text(note.text, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis,),
            onTap: () {onTap(note);},
            trailing: IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
