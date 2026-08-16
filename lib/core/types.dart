import 'package:flutter/material.dart';

enum Role {
  superAdmin,
  headOfDepartment,
  lecturer,
  classMonitor,
  assistant,
  student,
  staff,
}

const Map<Role, String> roleLabels = {
  Role.superAdmin: "Super Admin",
  Role.headOfDepartment: "Head of Department",
  Role.lecturer: "Lecturer",
  Role.classMonitor: "Class Monitor",
  Role.assistant: "Assistant",
  Role.student: "Student",
  Role.staff: "Staff",
};

const Map<Role, Color> roleColors = {
  Role.superAdmin: Color(0xFF7551FF),
  Role.headOfDepartment: Color(0xFF4A90D9),
  Role.lecturer: Color(0xFF9B59B6),
  Role.classMonitor: Color(0xFFF39C12),
  Role.assistant: Color(0xFF1ABC9C),
  Role.staff: Color(0xFF95A5A6),
  Role.student: Color(0xFF2ECC71),
};

enum ScreenKey {
  home,
  mark,
  history,
  leave,
  permission,
  reports,
  notifications,
  profile,
  settings,
  users,
  faceCapture,
  backup,
  attendanceDashboard,
  classAttendance,
}

const Map<ScreenKey, String> screenTitles = {
  ScreenKey.home: "Home",
  ScreenKey.mark: "Attendance Marking",
  ScreenKey.history: "Attendance History",
  ScreenKey.leave: "Leave Request",
  ScreenKey.permission: "Permission Request",
  ScreenKey.reports: "Reports",
  ScreenKey.notifications: "Notifications",
  ScreenKey.profile: "Profile",
  ScreenKey.settings: "Settings",
  ScreenKey.users: "User Management",
  ScreenKey.faceCapture: "Face Capture",
  ScreenKey.backup: "Backup & Restore",
  ScreenKey.attendanceDashboard: "Attendance Dashboard",
  ScreenKey.classAttendance: "Class Attendance",
};

enum RequestStatus { pending, approved, rejected }

class LeaveRequestItem {
  final String id;
  final String type; // "Leave" | "Permission"
  final String from;
  final String to;
  final String reason;
  RequestStatus status;
  final String createdAt;

  LeaveRequestItem({
    required this.id,
    required this.type,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
    required this.createdAt,
  });
}

class AttendanceRecordItem {
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String status; // "Present" | "Late" | "Absent" | "Leave"

  AttendanceRecordItem({
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
  });
}

class UserHistoryItem {
  final String id;
  final String user;
  final String role;
  final List<AttendanceRecordItem> records;

  UserHistoryItem({
    required this.id,
    required this.user,
    required this.role,
    required this.records,
  });
}

class ManagedUser {
  final String id;
  final String name;
  final String role;
  final String email;
  bool active;

  ManagedUser({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.active,
  });
}

class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String time;
  bool unread;
  final String kind; // "approval" | "warning" | "info"

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    required this.kind,
  });
}

class ApprovalRequestItem {
  final String id;
  final String user;
  final String userRole;
  final String type; // "Leave" | "Permission"
  final String from;
  final String to;
  final String reason;
  final String submittedAt;
  final String? recommender;
  RequestStatus status;

  ApprovalRequestItem({
    required this.id,
    required this.user,
    required this.userRole,
    required this.type,
    required this.from,
    required this.to,
    required this.reason,
    required this.submittedAt,
    this.recommender,
    required this.status,
  });
}

String getInitials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return "U";
  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return "${parts[0][0]}${parts[1][0]}".toUpperCase();
  }
  return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
}
