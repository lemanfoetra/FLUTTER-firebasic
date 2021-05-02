import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasic/screens/add_note_screen.dart';
import 'package:firebasic/screens/edit_note_screen.dart';
import 'package:firebasic/widgets/note.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User userAuth;

  ///
  /// Change Timestamp to Datetime
  ///
  DateTime toDateTime(Timestamp timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(
        timestamp.microsecondsSinceEpoch);
  }

  ///
  /// Move to Edit Note Screen
  ///
  void toEditNote(String documentId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditNoteScreen(documentId: documentId),
      ),
    );
  }

  ///
  /// Delet a Note
  ///
  Future<void> deleteNote(String documentId) async {
    await FirebaseFirestore.instance
        .collection('noted')
        .doc(documentId)
        .delete();
    print("delete $documentId");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userAuth = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 5),
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              underline: Container(), // hide underline
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('noted')
            .where('users_id', isEqualTo: userAuth.uid)
            .orderBy('updated_at', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text("Upps ada yang error.."),
            );
          } else if (snapshot.hasData) {
            final dataNote = snapshot.data.documents;
            if (dataNote.length > 0) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                itemCount: dataNote.length,
                itemBuilder: (context, index) {
                  return Note(
                    key: Key(dataNote[index].documentID),
                    deleteFn: deleteNote,
                    editFn: toEditNote,
                    documentId: dataNote[index].documentID,
                    title: dataNote[index]['title'],
                    value: dataNote[index]['value'],
                    updatedAt: toDateTime(dataNote[index]['updated_at']),
                  );
                },
              );
            } else {
              return Container(
                child: Center(
                  child: Text(
                      "Klik tombol plus di bawah untuk membuat note baru.. "),
                ),
              );
            }
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddNoteScreen.routeName);
        },
      ),
    );
  }
}
