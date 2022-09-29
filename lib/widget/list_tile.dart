import 'package:flutter/material.dart';

import '../domain/todo.dart';

class ListTileWidget extends StatefulWidget {
  final ToDo todo;
  const ListTileWidget({super.key, required this.todo});

  @override
  State<ListTileWidget> createState() => _ListTileWidgetState();
}

class _ListTileWidgetState extends State<ListTileWidget> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    Color leadingColor = Colors.blue;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: leadingColor,
        child: Text(
          widget.todo.name[0].toUpperCase(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        widget.todo.name,
        style: const TextStyle(fontSize: 20),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.todo.date,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "${isSelected == true ? 'Feito' : widget.todo.time}" 'h',
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
      selected: isSelected,
      selectedColor: Colors.green,
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected) {
          setState(() {
            leadingColor = Colors.green;
          });
        } else {
          setState(() {
            leadingColor = Colors.blue;
          });
        }
      },
    );
  }
}
