import 'package:flutter/material.dart';
import 'package:team_mobileforce_gong/models/note.dart';
import 'package:team_mobileforce_gong/util/noteDbhelper.dart';
import 'package:intl/intl.dart';


 NoteDbhelper helper  = NoteDbhelper();
final List<String> choices = const <String> [
  'Save Note & Back',
  'Delete Note',
  'Back to List'
];

const mnuSave = 'Save Note & Back';
const mnuDelete = 'Delete Note';
const mnuBack = 'Back to List';

class NoteDetail extends StatefulWidget {
  final Note note;
  NoteDetail(this.note);

  @override
  State<StatefulWidget> createState() => NoteDetailState(note);

}
class NoteDetailState extends State {
  Note note;
 NoteDetailState(this.note);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(note.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding( 
        padding: EdgeInsets.only(top:35.0, left: 10.0, right: 10.0),
        child: ListView(children: <Widget>[Column(
        children: <Widget>[
          TextField(
            controller: titleController,
            style: textStyle,
            onChanged: (value)=> this.updateTitle(),
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: textStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:15.0, bottom: 15.0),
            child: TextField(
            controller: descriptionController,
            style: textStyle,
            onChanged: (value) => this.updateDescription(),
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
            ),
          )),
        ],
      )],)
      )
    );
  }

  void select (String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (note.id == null) {
          return;
        }
        result = await helper.deleteNote(note.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Note"),
            content: Text("The Note has been deleted"),
          );
          showDialog(
            context: context,
            builder: (_) => alertDialog);
          
        }
        break;
        case mnuBack:
          Navigator.pop(context, true);
          break;
      default:
    }
  }

  void save() {
    note.date = new DateFormat.yMd().format(DateTime.now());
    if (note.id != null) {
      helper.updateNote(note);
    }
    else {
      helper.insertNote(note);
    }
    Navigator.pop(context, true);
  }


  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

}

