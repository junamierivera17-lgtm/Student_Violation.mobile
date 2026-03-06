import 'package:flutter/material.dart';
import '../models/violation_model.dart';
import '../services/api_service.dart';

class ViolationListPage extends StatefulWidget {
  const ViolationListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViolationListPageState createState() => _ViolationListPageState();
}

class _ViolationListPageState extends State<ViolationListPage> {
  final ApiService _api = ApiService();
  Future<List<ViolationModel>>? _violationsFuture;

  @override
  void initState() {
    super.initState();
    _fetchViolations();
  }

  void _fetchViolations() {
    setState(() {
      _violationsFuture = _api.getViolations();
    });
  }

  Future<void> _refreshViolations() async {
    _fetchViolations();
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'major':
        return Colors.red.shade700;
      case 'minor':
        return Colors.orange.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Violations'),
      ),
      body: FutureBuilder<List<ViolationModel>>(
        future: _violationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchViolations,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No violations found.'));
          }

          final violations = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshViolations,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: violations.length,
              itemBuilder: (context, index) {
                final violation = violations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: _getLevelColor(violation.level),
                      child: Text(
                        violation.level.isNotEmpty ? violation.level[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(violation.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(violation.description, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
