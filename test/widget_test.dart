import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_attendance_app/main.dart';
import 'package:school_attendance_app/screens/login_screen.dart';
import 'package:school_attendance_app/components/phone_frame.dart';

void main() {
  group('Smart Attendance App Unit & Widget Tests', () {
    testWidgets('App initializes and renders LoginScreen inside PhoneFrame',
        (WidgetTester tester) async {
      // Build the app and trigger a frame.
      await tester.pumpWidget(const SchoolAttendanceApp());
      await tester.pumpAndSettle();

      // Verify that the root app widget is present.
      expect(find.byType(SchoolAttendanceApp), findsOneWidget);

      // Verify that the phone container/frame is rendered.
      expect(find.byType(PhoneFrame), findsOneWidget);

      // Verify that the login screen is the initial unauthenticated screen.
      expect(find.byType(LoginScreen), findsOneWidget);

      // Verify that the Sign In title and email/password fields are present.
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Secure Access'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Toggle light and dark mode test', (WidgetTester tester) async {
      await tester.pumpWidget(const SchoolAttendanceApp());
      await tester.pumpAndSettle();

      // Get the MaterialApp widget and verify initial theme setup.
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.themeMode, equals(ThemeMode.light));
    });
  });
}
