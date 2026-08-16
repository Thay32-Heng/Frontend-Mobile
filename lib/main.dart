import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const SchoolAttendanceApp());
}

class SchoolAttendanceApp extends StatefulWidget {
  const SchoolAttendanceApp({Key? key}) : super(key: key);

  @override
  State<SchoolAttendanceApp> createState() => _SchoolAttendanceAppState();
}

class _SchoolAttendanceAppState extends State<SchoolAttendanceApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Attendance',
      debugShowCheckedModeBanner: false,
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      home: MainShell(
        dark: _dark,
        onToggleDark: (v) => setState(() => _dark = v),
      ),
    );
  }
}
