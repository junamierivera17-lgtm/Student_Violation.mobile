import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/violation_model.dart';
import '../services/api_service.dart';

class RecordViolationPage extends StatefulWidget {
  final StudentModel student;

  const RecordViolationPage({super.key, required this.student});

  @override
  // ignore: library_private_types_in_public_api
  _RecordViolationPageState createState() => _RecordViolationPageState();
}

class _RecordViolationPageState extends State<RecordViolationPage> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  ViolationModel? _selectedViolation;
  late Future<List<ViolationModel>> _violationsFuture;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _violationsFuture = ApiService().getViolations();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submitViolation() async {
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      if (_selectedViolation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a violation')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        await ApiService().recordViolation(
          studentId: widget.student.id,
          violationId: _selectedViolation!.id,
          remarks: _remarksController.text,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Violation recorded successfully')),
        );
        _formKey.currentState!.reset();
        _remarksController.clear();
        setState(() {
          _selectedViolation = null;
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to record violation: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Violation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student: ${widget.student.name}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              FutureBuilder<List<ViolationModel>>(
                future: _violationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error.toString()}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No violations found.'));
                  }

                  final violations = snapshot.data!;
                  return DropdownButtonFormField<ViolationModel>(
                    decoration: const InputDecoration(
                      labelText: 'Violation',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _selectedViolation,
                    items: violations.map((violation) {
                      return DropdownMenuItem<ViolationModel>(
                        value: violation,
                        child: Text(violation.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedViolation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a violation';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitViolation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
