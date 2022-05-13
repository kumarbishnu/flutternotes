import 'package:flutter/material.dart';
import 'package:flutternotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareDialog(BuildContext context) {
  return showGenericDialog(context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note!',
    optionBuilder: () => {
    'OK': null
    },
  );
}