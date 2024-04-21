import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: const TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _todoController = TextEditingController();
  final _todoValidation = ValidationBuilder().required().build();

  final List<String> _todos = <String>[];

  void _addTodo() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _todos.add(_todoController.text);
      _todoController.clear();
    });
  }

  void _editTodo(int index) {
    final formKey = GlobalKey<FormState>();
    final todoValidation = ValidationBuilder().required().build();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text('Edit Todo'),
            content: TextFormField(
              controller: TextEditingController(text: _todos[index]),
              validator: todoValidation,
              onChanged: (value) {
                _todos[index] = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _todoController,
                    validator: _todoValidation,
                    decoration: const InputDecoration(
                      labelText: 'Enter a new todo',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_todos[index]),
                onTap: () => _editTodo(index),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeTodo(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
