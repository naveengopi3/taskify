import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskify/models/todo_models.dart';
import 'package:taskify/service/todo_service.dart';
import 'package:taskify/utils/colors.dart';

class EditTodo extends StatefulWidget {
  final TodoModel todo;
  const EditTodo({super.key, required this.todo});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TodoService _todoService = TodoService();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    _taskController.text = widget.todo.todo;
    _selectedDate = widget.todo.date;
    _selectedTime = widget.todo.time;

    _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
    _timeController.text = DateFormat.jm().format(
      DateTime(0, 0, 0, _selectedTime!.hour, _selectedTime!.minute),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = DateFormat.jm().format(
          DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
        );
      });
    }
  }

  void _updateTodo() {
    if (_taskController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: CustomColors.kred,
        ),
      );
      return;
    }

    TodoModel updatedTodo = TodoModel(
      id: widget.todo.id,
      todo: _taskController.text.trim(),
      date: _selectedDate!,
      time: _selectedTime!,
      completed: widget.todo.completed,
    );

    _todoService
        .updateTodoDetails(updatedTodo)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("ToDo updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, updatedTodo);
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${error.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ToDo"),
        backgroundColor: CustomColors.korangeMedium,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColors.kgrey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColors.kgrey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: CustomColors.korangeMedium,
                      width: 1,
                    ),
                  ),
                  labelText: "Enter your task",
                  labelStyle: TextStyle(color: CustomColors.kgrey),
                ),
                controller: _taskController,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  labelText: "Select Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.kgrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: CustomColors.korangeMedium,
                      width: 1,
                    ),
                  ),

                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              SizedBox(height: 20),
              TextField(
                controller: _timeController,
                readOnly: true,
                onTap: _pickTime,
                decoration: InputDecoration(
                  labelText: "Select Time",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.kgrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: CustomColors.korangeMedium,
                      width: 1,
                    ),
                  ),
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.korangeMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _updateTodo,
                  child: Text(
                    'Update Todo',
                    style: TextStyle(color: CustomColors.kwhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
