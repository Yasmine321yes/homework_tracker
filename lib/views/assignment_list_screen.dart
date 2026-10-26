import 'package:flutter/material.dart';

import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _showAddAssignmentDialog() {
    _titleController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: TextField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Assignment name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();

                if (title.isNotEmpty) {
                  setState(() {
                    _presenter.addAssignment(title);
                  });
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteAll() {
    if (_presenter.assignments.isEmpty) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete all assignments?'),
          content: const Text(
            'This will remove every assignment from the list.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _presenter.clearAssignments();
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _presenter.assignments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          IconButton(
            onPressed: _confirmDeleteAll,
            tooltip: 'Delete all assignments',
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: assignments.isEmpty
          ? const Center(child: Text('No assignments yet.'))
          : ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];

                return CheckboxListTile(
                  title: Text(
                    assignment.title,
                    style: TextStyle(
                      decoration: assignment.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  value: assignment.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _presenter.toggleCompleted(index, value);
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssignmentDialog,
        tooltip: 'Add assignment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
