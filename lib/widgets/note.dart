import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Note extends StatefulWidget {
  final String documentId;
  final String title;
  final String value;
  final DateTime updatedAt;
  final void Function(String documentId) editFn;
  final void Function(String documentId) deleteFn;

  const Note({
    this.deleteFn,
    this.editFn,
    this.documentId,
    this.title,
    this.value,
    this.updatedAt,
    Key key,
  }) : super(key: key);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  bool longPressed = false;
  bool deletePressed = false;

  ///
  /// Format Datetime
  ///
  String timeFormat(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!deletePressed) widget.editFn(this.widget.documentId);
      },
      onLongPress: () {
        setState(() {
          longPressed = true;
        });
      },
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      this.widget.title.isNotEmpty
                          ? this.widget.title
                          : "Tanpa Judul",
                      overflow: TextOverflow.ellipsis,
                      style: this.widget.title.isNotEmpty
                          ? TextStyle(color: Colors.black87, fontSize: 16)
                          : TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        this.widget.value.length > 100
                            ? "${this.widget.value.substring(0, 100)} ...."
                            : this.widget.value,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Update ${timeFormat(this.widget.updatedAt)}",
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            !longPressed ? Container() : actionWidget
          ],
        ),
      ),
    );
  }

  ///
  /// Action Widget
  ///
  Widget get actionWidget {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: new BoxDecoration(
          border: new Border.all(
            color: Colors.transparent,
          ),
          color: new Color.fromRGBO(200, 0, 0, 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: deletePressed
              ? Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.deleteFn(widget.documentId);
                        setState(() {
                          deletePressed = true;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          longPressed = false;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
