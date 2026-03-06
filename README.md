📱 QR Code Violation Monitor — Flutter App

A Flutter mobile application that integrates a custom Student Violation Monitoring REST API to allow school staff to scan student QR codes and instantly record violations. The app provides a secure, real-time monitoring system designed for campus discipline management.

### API Choice

- API Name: Student Violation Monitoring API
- Base URL: <https://yourserver.com/api>
- Documentation: Internal REST API documentation
- Required: Yes (JWT Authentication)
- Response Format: JSON
It seems like you're looking for help with an issue in your Flutter app's code. From your description, I don’t see a specific line that you've indicated as problematic. Could you provide more context or clarify what the issue is? If it's related to a specific functionality or error message, please let me know!
The Student Violation Monitoring API delivers structured JSON data for managing students, violation types, scan logs, and disciplinary records. It supports secure authentication and role-based access (Admin, Staff, Mobile Scanner) while storing all records in a centralized database.

### Endpoints Integrated

| #  | Method | Path                     | Feature                                  |
|----|--------|--------------------------|----------------------------------------  |
| 1  | POST   | /login                   | Authenticate staff user                  |
| 2  | GET    | /students/{qrCode}       | Retrieve student information via QR code |
| 3  | GET    | /violations              | Fetch list of violation types            |
| 4  | POST   | /violations/record       | Record a student violation               |
| 5  | GET    | /violations/student/{id} | Retrieve violation history of a student  |

All endpoints are accessible through different screens in the mobile application.

### App Structure

lib/
├── main.dart                     # App entry point & bottom navigation
├── models/
│   ├── student_model.dart        # Student data model
│   ├── violation_model.dart      # Violation data model
│   └── record_model.dart         # Violation record model
├── services/
│   └── api_service.dart          # API communication using Dio
└── features/
    ├── login_page.dart           # Endpoint 1 — user authentication
    ├── home_page.dart            # Dashboard overview
    ├── scanner_page.dart         # Endpoint 2 — scan student QR
    ├── violation_list_page.dart  # Endpoint 3 — view violation types
    ├── student_detail_page.dart  # Student info + record violation
    └── violation_history_page.dart  # Endpoint 5 — student violation history

### Navigation

A BottomNavigationBar provides access to three primary sections:

- Home: Dashboard overview showing system status
- Scan:Scan student QR codes using the device camera
- Violations:View the list of minor and major violations

After scanning a QR code, the app navigates to the Student Detail Screen, where staff can:

1. View student information
2. Select a violation type
3. Record the violation

The Violation History Screen displays the full disciplinary record for the student.

### Implementation Details

HTTP Client

The app uses the Dio package with a centralized configuration:

```dart
final Dio _dio = Dio(BaseOptions(
  baseUrl: 'https://yourserver.com/api',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));

JWT tokens are stored using SharedPreferences and are automatically attached to requests for authenticated endpoints.

Data Models

- StudentModel: Represents the student record returned by the API with the following fields:
  - id
  - studentId
  - fullName
  - course
  - yearLevel
  - qrCode

- ViolationModel: Represents violation categories with the following fields:
  - id
  - violationName
  - category (Minor / Major)
  - description
  - sanction

- RecordModel: Represents recorded violation logs with the following fields:
  - id
  - studentId
  - violationId
  - date
  - recordedBy

All JSON responses are converted into typed Dart models before being used by the UI.

### Service Layer

ApiService centralizes all API communication. Widgets never call Dio directly; instead, they interact with typed service methods. Example methods include:

- `Future<StudentModel> getStudentByQR(String qrCode);`
- `Future<List<ViolationModel>> getViolations();`
- `Future<void> recordViolation(int studentId, int violationId);`
- `Future<List<RecordModel>> getStudentHistory(int studentId);`

This approach ensures a clear separation of networking logic from the UI layer.

### Error Handling

All API requests are wrapped in try/catch blocks to handle different scenarios:

- Network Errors: Displays an offline icon with a Retry button.
- Unauthorized (401): Automatically redirects to the Login screen.
- Empty Results: Displays a “No Data Found” message.
- Loading State: Shows a CircularProgressIndicator while data is loading.

### UI / Theme

The application adopts a School Security / Monitoring System Theme:

- Role Color Scheme:
  - Background: #F4F6F8 (light gray)
  - Headers / Navigation: #002147 (dark blue)
  - Buttons: #FDB913 (gold)
  - Cards: #FFFFFF
  - Error: #D32F2F

- Typography:
  - Poppins Bold: Page titles
  - Poppins Regular: Body text
  - Roboto Mono: Student IDs and QR data

The design emphasizes clarity, professionalism, and ease of use for school staff.

### Dependencies

yaml
dependencies:
  dio: ^5.4.0
  mobile_scanner: ^3.5.2
  google_fonts: ^6.2.1
  shared_preferences: ^2.2.2
  cupertino_icons: ^1.0.8

### Getting Started

Run the following commands:

bash
flutter pub get
flutter run

Ensure the backend API server is running before using the QR scanner feature.

### Selected Violations (Example)

Minor Violations:

- No ID
- Improper Uniform
- Late Entry
- No Haircut (for males)
- Earrings (for boys)
- Multiple piercings (for girls)

Major Violations:

- Smoking on campus
- Fighting
- Bullying
- Vandalism

### System Workflow

1. Staff logs into the mobile application.
2. Staff scans a student's QR code.
3. Student information is retrieved from the API.
4. Staff selects a violation type.
5. Violation is recorded and saved in the database.
6. Student violation history updates instantly.

### Grading Checklist (Self-Assessment)

| #  | Criterion                           | Status |
|----|-------------------------------------|--------|
| 1  | REST API implemented                | ✅     |
| 2  | JSON response format                | ✅     |
| 3  | 4+ endpoints integrated             | ✅     |
| 4  | QR code scanner integrated          | ✅     |
| 5  | Single HTTP client configuration    | ✅     |
| 6  | JSON mapped to Dart models          | ✅     |
| 7  | Service layer separate from UI      | ✅     |
| 8  | Error handling + loading states     | ✅     |
