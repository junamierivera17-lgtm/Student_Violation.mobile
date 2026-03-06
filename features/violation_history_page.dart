import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

class ViolationHistoryPage extends StatefulWidget {
  final StudentModel student;

  const ViolationHistoryPage({super.key, required this.student});

  @override
  State<ViolationHistoryPage> createState() =>
      _ViolationHistoryPageState();
}

class _ViolationHistoryPageState
    extends State<ViolationHistoryPage> {

  final ApiService _api = ApiService();

  bool _loading = true;
  bool _error = false;
  String _errorMessage = '';
  List<RecordModel> _records = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final result =
          await _api.getViolationHistory(widget.student.id);

      if (!mounted) return;

      setState(() {
        _records = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.student.name} History"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error,
                size: 50, color: Colors.red),
            const SizedBox(height: 10),
            Text(_errorMessage),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = false;
                });
                _loadHistory();
              },
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }

    if (_records.isEmpty) {
      return const Center(
        child: Text("No Violation History Found"),
      );
    }

    return ListView.builder(
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];

        return Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            leading: const Icon(Icons.warning,
                color: Colors.red),
            title: Text("Violation ID: ${record.violationId}"),
            subtitle: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text("Date: ${record.date}"),
                Text("Recorded By: ${record.recordedBy}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
