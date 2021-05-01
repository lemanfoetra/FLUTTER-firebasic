import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  const Note({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Judul',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Body',
                style: TextStyle(color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }
}
