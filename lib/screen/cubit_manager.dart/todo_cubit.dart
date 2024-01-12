import 'package:bloc/bloc.dart';
import 'package:cubit/screen/cubit_manager.dart/todo_state.dart';

class TodoManagement extends Cubit<TodoState> {
  final List<String> _todos = [];
  List<String> get todos => _todos;
  TodoManagement() : super(InitialTodoState());

  Future<void> addTodo({required String todo}) async {
    emit(LoadingTodoState());

    if (_todos.contains(todo)) {
      emit(ErrorTodoState(message: 'This Todo is already inputed'));
    } else {
      _todos.add(todo);
    }

    await Future.delayed(const Duration(seconds: 2));
    emit(LoadedTodoState(todos: _todos));
  }

  Future<void> removeTodo({required int index}) async {
    _todos.removeAt(index);
    if (todos.isEmpty) {
      LoadedTodoState(todos: _todos);
      emit(InitialTodoState());
    } else {
      emit(LoadedTodoState(todos: _todos));
    }
  }
}
