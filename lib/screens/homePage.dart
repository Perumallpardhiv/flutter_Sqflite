import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sql_todo/models/todo_model.dart';
import 'package:sql_todo/screens/editAddTodo.dart';
import 'package:sql_todo/screens/viewTodo.dart';
import 'package:sql_todo/utilities/db_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late List<todomodel> todos;
  late dbHelper helper;
  bool isLoading = false;

  @override
  void initState() {
    helper = dbHelper.instance;
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
    helper.close();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    this.todos = await helper.readAllTodo();
    setState(() {
      isLoading = false;
    });
  }

  final _lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : todos.isEmpty
                ? Text(
                    "No Notes",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshNotes(),
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(8),
                      itemCount: todos.length,
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.fit(2);
                      },
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return GestureDetector(
                          onTap: () async {
                            print(todo.id);
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => viewtodo(id: todo.id!)));
                            refreshNotes();
                          },
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: index % 2 == 0
                                ? DismissDirection.endToStart
                                : DismissDirection.startToEnd,
                            onDismissed: (direction) async {
                              final storeTodo = todo;
                              await helper.delete(todo.id!);
                              final snackBar = SnackBar(
                                content: Text('🤯 Note Deleted '),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    helper.create(storeTodo);
                                    refreshNotes();
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            background: Container(
                              constraints: BoxConstraints(
                                  minHeight: index % 4 == 0
                                      ? 100
                                      : index % 4 == 1
                                          ? 150
                                          : index % 4 == 2
                                              ? 150
                                              : 100),
                              padding: EdgeInsets.all(8),
                              color: Colors.red,
                              alignment: index % 2 == 0
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                            child: Card(
                              color: _lightColors[index % _lightColors.length],
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        minHeight: index % 4 == 0
                                            ? 100
                                            : index % 4 == 1
                                                ? 150
                                                : index % 4 == 2
                                                    ? 150
                                                    : 100),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat.yMMMd()
                                              .add_jm()
                                              .format(todo.date),
                                          style: TextStyle(
                                              color: Colors.grey.shade700),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            todo.status
                                                ? Icon(Icons.label_important,
                                                    color: Colors.red)
                                                : Icon(
                                                    Icons
                                                        .airline_seat_recline_extra,
                                                    color: Colors.green[800],
                                                  ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              todo.title,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            color: todo.number == 1
                                                ? Colors.grey[50]
                                                : todo.number == 2
                                                    ? Colors.grey[300]
                                                    : todo.number == 3
                                                        ? Colors.grey[400]
                                                        : todo.number == 4
                                                            ? Colors.grey
                                                            : todo.number == 5
                                                                ? Colors
                                                                    .grey[600]
                                                                : todo.number ==
                                                                        6
                                                                    ? Colors.grey[
                                                                        800]
                                                                    : Colors
                                                                        .transparent,
                                            child: Text(
                                              "IMP: ${todo.number.toString()}",
                                              style: TextStyle(
                                                color: todo.number <= 4
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => editTodo()));
          refreshNotes();
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
