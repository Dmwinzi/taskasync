TaskSync - Flutter Task Management App

Overview
Task async is a flutter application for managing user tasks with added features like notification when tasks are due

Features
- Task List Screen: Displays all tasks with their priority and completion status.
- Task Creation Dialogue: Allows users to add new tasks with a title, priority, and optional due date.
- Task management: Create, Read, Update (toggle completion), and Delete tasks.
- Local Persistence: Tasks are stored in a local tasks.json file.


 Native Android Integration
- Task Reminders: Uses Flutter platform channels to schedule reminders for tasks with a due date.

Tech Stack
- Flutter 3.x
- Dart 3.x
- State Management: Stacked (ViewModel-based architecture)
- Local Storage: JSON file handling
- Platform Channels: Native Android integration for reminders
- created a unique task card with progress indicators  instead of a dashboard

Project Structure
Project Structure

lib/

main.dart - Entry point

data/

models/TaskModel.dart - Data models

repositories/TaskRepository.dart - Data handling logic

domain/

entities/TaskEntity.dart - Core business logic

usecases/TaskUseCase.dart - Application logic

presentation/

viewmodels/TaskViewModel.dart - Stacked ViewModel

views/TaskScreens.dart - UI Screens

assets/

tasks.json - Local task storage

test/ - Unit & widget tests

Mocks/ - Contains mock implementations for testing

task_viewmodel_test.dart - Tests for TaskViewModel

Author
Daniel Mwinzi


