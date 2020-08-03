import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thenote/model/note.dart';
import 'package:thenote/util/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final Note note;

  NoteDetail(this.note);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  NoteDetailState(this.note);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
        backgroundColor: Color(0xFF21BFBD),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Note',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.wb_sunny),
              onPressed: () {},
              color: Color(0xFF21BFBD),
            )
          ],
        ),
        body: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height - 82.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent),
                  Positioned(
                      top: 75.0,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45.0),
                                topRight: Radius.circular(45.0),
                              ),
                              color: Colors.white),
                          height: MediaQuery.of(context).size.height - 100.0,
                          width: MediaQuery.of(context).size.width)),
                  Positioned(
                    top: 200.0,
                    left: 25.0,
                    right: 25.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: titleController,
                            validator: (value) =>
                                value.isEmpty ? 'Please enter title' : null,
                            onChanged: (value) {
                              note.title = titleController.text;
                            },
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                ),
                                labelText: 'Title',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: TextField(
                            controller: descriptionController,
                            onChanged: (value) {
                              note.description = descriptionController.text;
                            },
                            decoration: InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                        Container(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                color: Color(0xDD009D9B),
                                textColor: Colors.white,
                                child: Text(
                                  'Save',
                                  textScaleFactor: 1.5,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_formKey.currentState.validate()) {
                                      _save();
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: 15.0,
                            ),
                            Expanded(
                              child: RaisedButton(
                                color: Color(0xDD009D9B),
                                textColor: Colors.white,
                                child: Text(
                                  'Cancel',
                                  textScaleFactor: 1.5,
                                ),
                                onPressed: () {
                                  setState(() {
                                    moveToLastScreen();
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ])));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog("Status", 'Note saved successfully!');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
