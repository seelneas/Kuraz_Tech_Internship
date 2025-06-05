import 'package:flutter/material.dart';

void main() => runApp(const TaskManagerApp());

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TaskManagerHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskManagerHome extends StatefulWidget {
  const TaskManagerHome({super.key});

  @override
  State<TaskManagerHome> createState() => _TaskManagerHomeState();
}

class _TaskManagerHomeState extends State<TaskManagerHome> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      _tasks.add(Task(title: title));
      _controller.clear();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Widget _buildTaskItem(BuildContext context, int index) {
    final task = _tasks[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) => _toggleTask(index),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _deleteTask(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Simple Task Manager'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new task...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _addTask,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.teal, size: 30),
                  onPressed: () => _addTask(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      '🎉 No tasks yet.\nAdd a task to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: _buildTaskItem,
                  ),
          ),
        ],
      ),
    );
  }
}
