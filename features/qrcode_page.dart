import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';
import 'student_details_page.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final ApiService _api = ApiService();
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to read QR code')),
      );
      return;
    }

    _processCode(code);
  }

  void _processCode(String code) {
    if (_isProcessing) return; 

    setState(() {
      _isProcessing = true;
    });

    _fetchStudent(code);
  }

  Future<void> _fetchStudent(String qrCode) async {
    try {
      final student = await _api.getStudentByQR(qrCode);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => StudentDetailsPage(student: student),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            onDetect: _onDetect,
          ),

          // Show a processing indicator when fetching data
          if (_isProcessing)
            const CircularProgressIndicator(),

          // Add a simulation button at the bottom for testing
          Positioned(
            bottom: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _isProcessing ? null : () => _processCode('12345'),
              child: const Text('Simulate Scan (QR="12345")'),
            ),
          ),
        ],
      ),
    );
  }
}
