import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskify/models/todo_models.dart';
import 'package:taskify/service/todo_service.dart';
import 'package:taskify/utils/colors.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _taskcontroller = TextEditingController();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TodoService _todoService = TodoService();

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
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

  void _addTodo() {
    if (_taskcontroller.text.isEmpty ||
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
    TodoModel newTodo = TodoModel(
      id: '',
      todo: _taskcontroller.text.trim(),
      date: _selectedDate!,
      time: _selectedTime!,
    );

    _todoService
        .addTodo(newTodo)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("ToDo added successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
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
        title: Text("Add ToDo"),
        backgroundColor: CustomColors.korangeMedium,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                controller: _taskcontroller,
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
                  onPressed: _addTodo,
                  child: Text(
                    'Add ToDo',
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
