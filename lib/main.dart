import "package:flutter/material.dart";
import 'package:thenote/screens/note_detail.dart';
import 'package:thenote/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note Keeper",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorLight: Color(0xDD009D9B),
      ),
      home: NoteList(),
    );
  }
}
