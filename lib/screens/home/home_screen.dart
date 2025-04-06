import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:taskify/screens/edit_todos/edit_todo.dart';
import 'package:taskify/models/todo_models.dart';
import 'package:taskify/screens/add_todo/add_todo.dart';
import 'package:taskify/screens/profile_screen/profile_screen.dart';
import 'package:taskify/service/todo_service.dart';
import 'package:taskify/widget/todo_card.dart';
import 'package:taskify/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final TodoService _todoService = TodoService(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taskify"),
        backgroundColor: CustomColors.korangeMedium,
        actions: [
          IconButton(
            icon: Icon(Icons.person,size: 30,),
            onPressed: ()  {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(),));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EasyDateTimeLinePicker(
            focusedDate: _selectedDate,
            firstDate: DateTime(2010, 3, 18),
            lastDate: DateTime(2030, 3, 18),
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            headerOptions: HeaderOptions(headerType: HeaderType.picker),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Today tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TodoModel>>(
              stream: _todoService.getTodos(),
              builder: (context, snapshot) {
                if (!mounted) return SizedBox();
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final todos = snapshot.data!;

                // Filter todos for the selected date
                final filteredTodos =
                    todos.where((todo) {
                      return todo.date.year == _selectedDate.year &&
                          todo.date.month == _selectedDate.month &&
                          todo.date.day == _selectedDate.day;
                    }).toList();

                if (filteredTodos.isEmpty) {
                  return Center(
                    child: Text(
                      'No tasks for today.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];
                            return TodoCard(
                              todo: todo,
                              onDelete: () async {
                                await _todoService.deleteTodo(todo.id);
                              },
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTodo(todo: todo),
                                  ),
                                );
                              },
                              onChecked: (value) async {
                                if (value != null) {
                                  await _todoService.updateTodoStatus(
                                    todo.id,
                                    value,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: CustomColors.korangeMedium,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodo()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
