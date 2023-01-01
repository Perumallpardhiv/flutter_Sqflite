import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sql_todo/models/todo_model.dart';
import 'package:sql_todo/utilities/db_helper.dart';

class editTodo extends StatefulWidget {
  final todomodel? todo_model;

  editTodo({this.todo_model});

  @override
  State<editTodo> createState() => _editTodoState();
}

class _editTodoState extends State<editTodo> {
  final _formKey = GlobalKey<FormState>();
  late dbHelper helper;
  late bool status;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    helper = dbHelper.instance;

    status = widget.todo_model?.status ?? false;
    number = widget.todo_model?.number ?? 0;
    title = widget.todo_model?.title ?? '';
    description = widget.todo_model?.description ?? '';
  }
  
  @override
  Widget build(BuildContext context) {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: isFormValid ? null : Colors.grey.shade700,
              ),
              onPressed: () async {
                if (isFormValid) {
                  if (widget.todo_model == null) {
                    final todo = todomodel(
                      id: Random().nextInt(1000),
                      number: number,
                      title: title,
                      description: description,
                      status: status,
                      date: DateTime.now(),
                    );
                    await helper.create(todo);
                  } else if (widget.todo_model != null) {
                    final todo = todomodel(
                      id: widget.todo_model!.id,
                      status: status,
                      title: title,
                      description: description,
                      number: number,
                      date: widget.todo_model!.date,
                    );
                    await helper.update(todo);
                  }
                  Navigator.pop(context, true);
                }
              },
              child: Text("Save"),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Switch(
                        value: status,
                        onChanged: (value) {
                          setState(() {
                            status = value;
                          });
                        }),
                    Expanded(
                      child: Slider(
                        value: (number).toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        onChanged: (value) {
                          setState(() {
                            number = value.toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  maxLines: 1,
                  initialValue: title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  validator: (title) => title != null && title.isEmpty
                      ? 'The title cannot be empty'
                      : null,
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  maxLines: 5,
                  initialValue: description,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type Something... ',
                    hintStyle: TextStyle(color: Colors.white60),
                  ),
                  validator: (title) => title != null && title.isEmpty
                      ? 'The description cannot be empty'
                      : null,
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
