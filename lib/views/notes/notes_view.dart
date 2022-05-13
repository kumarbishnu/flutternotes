import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
import 'package:flutternotes/views/notes/notes_list_view.dart';

import '../../enums/menu_action.dart';
import '../../services/crud/notes_service.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    AuthService.firebase().logout();
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        return NotesListView(
                          notes: snapshot.data as List<DatabaseNote>,
                          onTap: (note) {Navigator.pushNamed(context, AppRoutes.editNote, arguments: note);},
                          onDeleteNote: (note) async {await _notesService.deleteNote(id: note.id);},
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.editNote);
        },
      ),
    );
  }
}
