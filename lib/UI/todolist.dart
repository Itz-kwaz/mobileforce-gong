import 'package:flutter/material.dart';
import 'package:team_mobileforce_gong/models/note.dart';
import 'package:team_mobileforce_gong/util/noteDbhelper.dart';
import 'package:team_mobileforce_gong/UI/tododetail.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState(); 
  
}

class TodoListState extends State {
  NoteDbhelper helper = NoteDbhelper();
  List<Note> notes;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (notes == null) {
      notes = List<Note>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note("", "",""));
        }
        ,
        tooltip: "Add new Todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(this.notes[position].title),
            subtitle: Text(this.notes[position].description),
            onTap: () {
              debugPrint("Tapped on " + this.notes[position].id.toString());
              navigateToDetail(this.notes[position]);
            },
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getNotes();
      todosFuture.then((result) {
        List<Note> todoList = List<Note>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Note.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          notes = todoList;
          count = count;
        });
        debugPrint("Items " + count.toString());
      });
    });
  }


  void navigateToDetail(Note todo) async {
    bool result = await Navigator.push(context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          return NoteDetail(todo);
        },
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(
            opacity: animation1,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 2000),
      ),
    );
    if (result == true) {
      getData();
    }
  }


}
