import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutternotes/services/cloud/cloud_note.dart';
import 'package:flutternotes/services/cloud/cloud_storage_constants.dart';
import 'package:flutternotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  FirebaseCloudStorage._sharedInstance();

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CloudNote>> allNotes({required String ownerId}) =>
      notes
          .where(CloudStorageConstants.ownerId, isEqualTo: ownerId)
          .snapshots()
          .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));

  Future<CloudNote> createNewNote({required String ownerId}) async {
    final document = await notes.add({
      CloudStorageConstants.ownerId: ownerId,
      CloudStorageConstants.textField: ''
    });
    final newNote = await document.get();
    return CloudNote(
      documentId: newNote.id,
      ownerId: ownerId,
      text: ''
    );
  }

  Future<void> updateNote({required String documentId, required String text}) async {
    try {
      await notes
          .doc(documentId)
          .update({CloudStorageConstants.textField: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes
          .doc(documentId)
          .delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}
