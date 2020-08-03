import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thenote/model/note.dart';
import 'package:thenote/util/database_helper.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int counter = 0;
  Note note;
  DatabaseHelper helper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50.0,
              ),
              Container(
                width: 125.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 25.0),
        Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            children: <Widget>[
              Text('Notes',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0)),
            ],
          ),
        ),
        SizedBox(height: 40.0),
        Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height - 300.0,
                        child: ListView(children: [
                          listViewElement(),
                        ]))),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 240.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        navigateToDetail(Note('', '', 2));
                      },
                      child: Container(
                        height: 55.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xDD009D9B)),
                        child: Center(
                            child: Text('Add',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0))),
                      ),
                    ),
                  )
                ])
              ],
            ))
      ]),
    );
  }

  //Used to create custom widget instead of using list tile
  Widget listViewElement() {
    //int position;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: counter,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: InkWell(
                    onTap: () {
                      print("dialog ");
                      navigateToDetail(this.noteList[position]);
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(this.noteList[position].title,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold)),
                              Text(this.noteList[position].date,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15.0,
                                      color: Colors.grey)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                  onPressed: () {
                    AlertDialog alertDialog = AlertDialog(
                      title: Text("Delete"),
                      content: Text('Do you want to delete?'),
                      actions: <Widget>[
                        FlatButton(
                            child: Text(
                              "No",
                              style: TextStyle(color: Color(0xDD009D9B)),
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context, true);
                              });
                            }),
                        FlatButton(
                            child: Text("Yes",
                                style: TextStyle(color: Color(0xDD009D9B))),
                            onPressed: () {
                              _delete(context, noteList[position]);
                              setState(() {
                                Navigator.pop(context, true);
                              });
                            }),
                      ],
                    );
                    showDialog(context: context, builder: (_) => alertDialog);
                  },
                )
              ],
            ),
          );
        });
  }

  void navigateToDetail(Note note) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note);
    }));

    if (result == true) {
      updateListView();
    }
  }

  //for deleting a note
  void _delete(BuildContext context, Note note) async {
    var result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note deleted successfully');
    }
  }

  //Used to show a message of the statue
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
    updateListView();
  }

  //Used to update the list view based on changes made
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.counter = noteList.length;
        });
      });
    });
  }
}
