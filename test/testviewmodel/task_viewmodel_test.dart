import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked/stacked.dart';
import 'package:task_async/Domain/Entities/Taskentity.dart';
import 'package:task_async/Presentation/Viewmodel/Taskviewmodel.dart';
import '../Mocks/mockusecase.mocks.dart';

void main() {
  late Taskviewmodel viewmodel;
  late MockTaskusecase mockTaskUseCase;

  setUp(() {
    mockTaskUseCase = MockTaskusecase();
    viewmodel = Taskviewmodel(mockTaskUseCase);
  });

  test('fetch tasks from storage', () async {
    final taskList = [
      Taskentity(id: 1, title: 'Test Task', priority: 'High', completed: "not started", dueDate: '2025-03-18')
    ];

    when(mockTaskUseCase.gettasks()).thenAnswer((_) async => taskList);

    await viewmodel.fetchTasks();

    expect(viewmodel.tasks, equals(taskList));
    verify(mockTaskUseCase.gettasks()).called(1);
  });

  test('add a task and persist it', () async {
    final newTask = Taskentity(id: 2, title: 'New Task', priority: 'Medium', completed: "not started", dueDate: '2025-03-20');

    when(mockTaskUseCase.addtask(any)).thenAnswer((_) async => newTask);

    await viewmodel.addTask(newTask);

    expect(viewmodel.tasks.contains(newTask), isTrue);
    verify(mockTaskUseCase.addtask(any)).called(1);
  });

  test('update an existing task and persist changes', () async {
    final task = Taskentity(id: 1, title: 'Initial Task', priority: 'Low', completed: "not started", dueDate: '2025-03-21');
    viewmodel.tasks.add(task);

    final updatedTask = task.copyWith(title: 'Updated Task');
    when(mockTaskUseCase.updatetask(any)).thenAnswer((_) async => updatedTask);

    await viewmodel.updateTask(updatedTask);

    expect(viewmodel.tasks.first.title, 'Updated Task');
    verify(mockTaskUseCase.updatetask(any)).called(1);
  });

  test('delete task and update JSON file', () async {
    final task = Taskentity(id: 1, title: 'Delete Task', priority: 'High', completed: "not started", dueDate: '2025-03-18');
    viewmodel.tasks.add(task);

    when(mockTaskUseCase.deletetask(any)).thenAnswer((_) async => 'Deleted');

    await viewmodel.deleteTask(1);

    expect(viewmodel.tasks.any((t) => t.id == 1), isFalse);
    verify(mockTaskUseCase.deletetask(1)).called(1);
  });
}
