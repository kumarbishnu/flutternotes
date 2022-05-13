import 'package:flutter/widgets.dart';
import 'package:flutternotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'An error occurred',
    content: text,
    optionBuilder: () => {'OK': null,},
  );
}