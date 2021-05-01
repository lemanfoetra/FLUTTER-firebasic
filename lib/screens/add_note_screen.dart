import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  static const routeName = "/add_note_screen";

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final valueControlller = TextEditingController();
  bool savingProcess = false;

  Future<void> saveNote() async {
    setState(() {
      savingProcess = true;
    });
    FocusScope.of(context).unfocus();
    final userAuth = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = {
      "users_id": userAuth.uid,
      "users_phone": userAuth.phoneNumber,
      "title": titleController.text,
      "value": valueControlller.text,
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
    };
    var result = await FirebaseFirestore.instance.collection('noted').add(data);
    setState(() {
      savingProcess = false;
    });
    print(result);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        actions: [
          savingProcess
              ? Container(
                  padding: EdgeInsets.only(right: 30),
                  child: Center(
                    child: Container(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(right: 25),
                    child: Center(child: Icon(Icons.check, size: 25)),
                  ),
                  onTap: () async {
                    await saveNote();
                  },
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Judul note",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 5,
                  bottom: 5,
                ),
                child: TextFormField(
                  controller: valueControlller,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tulis sesuatu disini...",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
