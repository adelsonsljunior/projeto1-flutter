import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/domain/todo.dart';
import 'package:todo_list/pages/add_to_do.dart';
import 'package:todo_list/widget/list_tile.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  List<ToDo> list = [];

  setupTodo() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs.getString('todo');
    if (stringTodo != null) {
      List todoList = jsonDecode(stringTodo);
      for (var element in todoList) {
        setState(() {
          list.add(ToDo.fromJson(element));
        });
      }
    }
  }

  saveTodo() {
    List items = list.map((e) => e.toJson()).toList();
    prefs.setString('todo', jsonEncode(items));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
          leading: IconButton(
            tooltip: 'Marcar todas como feitas',
            icon: const Icon(
              Icons.check,
              color: Colors.green,
              size: 30,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                            'Marcar todas as tarefas como concluídas?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Não')),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  list.clear();
                                });

                                saveTodo();

                                Navigator.pop(context);
                              },
                              child: const Text('Sim')),
                        ],
                      ));
            },
          ),
        ),
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Dismissible(
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirme"),
                          content: const Text(
                              "Tem certeza que deseja excluir essa tarefa?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCELAR")),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("APAGAR"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      list.removeAt(index);
                    });
                    saveTodo();
                  },
                  key: Key(list[index].name.toString()),
                  child: ListTileWidget(todo: list[index]));
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddToDo();
            })).then((value) {
              if (value != null) {
                setState(() {
                  list.add(value);
                });
                saveTodo();
              }
            });
          },
        ));
  }
}
