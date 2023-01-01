import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sql_todo/models/todo_model.dart';
import 'package:sql_todo/screens/editAddTodo.dart';
import 'package:sql_todo/utilities/db_helper.dart';

class viewtodo extends StatefulWidget {
  final int id;
  viewtodo({
    required this.id,
  });

  @override
  State<viewtodo> createState() => _viewtodoState();
}

class _viewtodoState extends State<viewtodo> {
  late todomodel todo;
  late dbHelper helper;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    helper = dbHelper.instance;
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.todo = await helper.readTodo(widget.id);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              if (isLoading) return;
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => editTodo(
                  todo_model: todo,
                ),
              ));
              refreshNote();
            },
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () async {
              final storeTodo = todo;
              await helper.delete(todo.id!);
              Navigator.pop(context);
              final snackBar = SnackBar(
                content: Text('🤯 Note Deleted '),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    helper.create(storeTodo);
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(todo.date),
                    style: TextStyle(color: Colors.white38),
                  ),
                  SizedBox(height: 8),
                  Text(
                    todo.description,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }
}
