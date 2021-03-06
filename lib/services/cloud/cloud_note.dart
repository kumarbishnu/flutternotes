import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerId,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
      documentId = snapshot.id,
      ownerId = snapshot.data()[CloudStorageConstants.ownerId],
      text = snapshot.data()[CloudStorageConstants.textField];
}
