import 'package:flutter/material.dart';
import 'package:flutternotes/services/cloud/cloud_note.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
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
        final note = notes.elementAt(index);
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
