import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  static const routeName = "/edit_note_screen";
  final String documentId;

  EditNoteScreen({this.documentId});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final titleController = TextEditingController();
  final valueControlller = TextEditingController();
  bool savingProcess = false;
  bool loadData = false;

  ///
  /// Get data from server
  ///
  Future<void> _getData() async {
    setState(() {
      loadData = true;
    });
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection('noted')
        .doc(widget.documentId)
        .get();
    titleController.text = data.data()['title'];
    valueControlller.text = data.data()['value'];
    setState(() {
      loadData = false;
    });
  }

  ///
  /// Update Note
  ///
  Future<void> saveNote() async {
    setState(() {
      savingProcess = true;
    });
    FocusScope.of(context).unfocus();
    Map<String, dynamic> data = {
      "title": titleController.text,
      "value": valueControlller.text,
      "updated_at": Timestamp.now(),
    };
    await FirebaseFirestore.instance
        .collection('noted')
        .doc(widget.documentId)
        .update(data);
    setState(() {
      savingProcess = false;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleController.text.isNotEmpty ? titleController.text : "Edit Note",
        ),
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
      body: loadData
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
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
