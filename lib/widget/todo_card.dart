import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:taskify/models/todo_models.dart';
import 'package:taskify/utils/colors.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<bool?> onChecked;
  const TodoCard({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onEdit,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(todo.id),
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        color: todo.completed ? Colors.green : Colors.blue,
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.todo,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                maxLines: 5,
                overflow: TextOverflow.visible,
                strutStyle: StrutStyle(fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                DateFormat.jm().format(
                  DateTime(0, 0, 0, todo.time.hour, todo.time.minute),
                ),

                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.kwhite,
                ),
                maxLines: 1,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
                  Checkbox(value: todo.completed, onChanged: onChecked),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
