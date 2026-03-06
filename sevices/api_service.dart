import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/record_model.dart';
import '../models/student_model.dart';
import '../models/violation_model.dart';

class ApiService {
  final Dio _dio;

  // Private constructor
  ApiService._internal()
      : _dio = Dio(BaseOptions(
          // For Android Emulator
          baseUrl: 'http://10.0.2.2:3000/api',
          // For iOS Simulator & Physical Devices
          // baseUrl: 'http://localhost:3000/api',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  // Singleton instance
  static final ApiService _instance = ApiService._internal();

  // Factory constructor to return the same instance
  factory ApiService() {
    return _instance;
  }

  // ================= ERROR HANDLER =================
  dynamic _extractData(Response response) {
    try {
      if (response.statusCode == 200) {
        // Assuming the actual data is nested under a 'data' key.
        // This is a common practice in many APIs.
        if (response.data != null && response.data['data'] != null) {
          return response.data['data'];
        }
        // If there is no 'data' key, return the response body directly.
        return response.data;
      }
    } catch (e) {
      log('Error extracting data: $e');
    }
    // Return null if extraction fails or status code is not 200.
    return null;
  }

  // ================= GET STUDENT BY QR =================
  Future<StudentModel> getStudentByQR(String qrCode) async {
    try {
      final response = await _dio.get('/students/qr/$qrCode');
      final data = _extractData(response);

      if (data != null) {
        return StudentModel.fromJson(data);
      } else {
        throw Exception("Student not found.");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to fetch student",
      );
    }
  }

  // ================= GET ALL VIOLATIONS =================
  Future<List<ViolationModel>> getViolations() async {
    try {
      final response = await _dio.get('/violations');
      final data = _extractData(response);

      if (data != null && data is List) {
        return data.map((v) => ViolationModel.fromJson(v)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to fetch violations",
      );
    }
  }

  // ================= RECORD VIOLATION =================
  Future<void> recordViolation({
    required int studentId,
    required int violationId,
    required String remarks,
  }) async {
    try {
      await _dio.post(
        '/violations/record',
        data: {
          "studentId": studentId,
          "violationId": violationId,
          "remarks": remarks,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Failed to record violation",
      );
    }
  }

  // ================= GET VIOLATION HISTORY =================
  Future<List<RecordModel>> getViolationHistory(int studentId) async {
    try {
      final response = await _dio.get('/students/$studentId/violations');
      final data = _extractData(response);

      if (data == null) return [];

      return (data as List).map((e) => RecordModel.fromJson(e)).toList();
    } on DioException catch (e) {
      log(e.toString());
      throw Exception(
        e.response?.data['message'] ?? "Failed to fetch violation history",
      );
    }
  }

  // ================= LOGIN =================
  Future<void> login(String email, String password) async {
    // Simulate a successful login for now.
    log('Simulating successful login for $email');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  }

  // ================= SIGNUP =================
  Future<void> signup(
      String name, String email, String password, String role) async {
    try {
      // This is a mock signup. In a real app, you would make a POST request.
      log('Attempting to sign up: $name, $email, $role');
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      log('Signup successful for $name ($email) as a $role');
    } catch (e) {
      // This block will not be reached in the simulation, but it's good practice.
      throw Exception('Signup failed.');
    }
  }
}
