import 'package:cubit/screen/cubit_manager.dart/todo_cubit.dart';
import 'package:cubit/screen/cubit_manager.dart/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  late double usefulHeight = MediaQuery.of(context).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top;
  late final TodoManagement cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TodoManagement>(context);
    _controller = TextEditingController();
    cubit.stream.listen((state) {
      if (state is ErrorTodoState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.message,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('State Management with Cubit'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder(
              bloc: cubit,
              builder: (_, state) {
                if (state is InitialTodoState) {
                  return SizedBox(
                    height: usefulHeight * 0.91,
                    child: const Center(
                      child: Text(
                        'There`s no data to show',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                } else if (state is LoadingTodoState) {
                  return SizedBox(
                    height: usefulHeight * 0.91,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is LoadedTodoState) {
                  return todoListView(state.todos);
                } else {
                  return todoListView(cubit.todos);
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: usefulHeight * 0.09,
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Input your task here.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mandatory field.';
                      } else if (value.length < 5) {
                        return 'Too short field.';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      cubit.addTodo(todo: _controller.text);
                      _controller.clear();
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox todoListView(List<String> todos) {
    return SizedBox(
      height: usefulHeight * 0.91,
      child: ListView.separated(
        separatorBuilder: (_, index) => const Divider(),
        itemCount: todos.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(todos[index]),
            leading: CircleAvatar(
              child: Text(todos[index][0]),
            ),
            trailing: IconButton(
              color: Colors.red[300],
              onPressed: () {
                cubit.removeTodo(index: index);
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
          );
        },
      ),
    );
  }
}
