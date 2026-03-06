import 'package:flutter/material.dart';
import '../models/student_model.dart';
import 'violation_history_page.dart';
import 'record_violation_page.dart';

class StudentDetailsPage extends StatelessWidget {
  final StudentModel student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('ID'),
                      subtitle: Text(student.studentId,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(student.email,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.school),
                      title: const Text('Course'),
                      subtitle: Text(student.course ?? 'N/A',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                     const Divider(),
                    ListTile(
                      leading: const Icon(Icons.format_list_numbered),
                      title: const Text('Year Level'),
                      subtitle: Text(student.yearLevel?.toString() ?? 'N/A',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(), // Pushes buttons to the bottom
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.history),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ViolationHistoryPage(student: student),
                        ),
                      );
                    },
                    label: const Text('History'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              RecordViolationPage(student: student),
                        ),
                      );
                    },
                    label: const Text('New Violation'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Some padding at the bottom
          ],
        ),
      ),
    );
  }
}
