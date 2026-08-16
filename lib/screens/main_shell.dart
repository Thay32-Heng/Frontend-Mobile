import 'package:flutter/material.dart';

import '../core/types.dart';
import '../components/phone_frame.dart';
import '../components/top_bar.dart';
import '../components/bottom_nav.dart';
import '../components/role_switcher.dart';
import '../components/draw_canvas.dart';

import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'attendance_mark_screen.dart';
import 'face_capture_screen.dart';
import 'history_screen.dart';
import 'request_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'user_management_screen.dart';
import 'backup_screen.dart';
import 'attendance_dashboard_screen.dart';
import 'class_attendance_screen.dart';

class MainShell extends StatefulWidget {
  final bool dark;
  final ValueChanged<bool> onToggleDark;

  const MainShell({
    Key? key,
    required this.dark,
    required this.onToggleDark,
  }) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _authed = false;
  Role _role = Role.superAdmin;
  String _email = "admin@school.edu";
  ScreenKey _screen = ScreenKey.home;
  final List<ScreenKey> _stack = [];
  bool _retrainRequired = false;
  bool _needsOnboarding = false;
  bool _roleSwitcherOpen = false;
  bool _drawCanvasOpen = false;

  void _navigate(ScreenKey k) {
    if (k != _screen) {
      _stack.add(_screen);
    }
    setState(() {
      _screen = k;
    });
  }

  void _back() {
    setState(() {
      if (_stack.isNotEmpty) {
        _screen = _stack.removeLast();
      } else {
        _screen = ScreenKey.home;
      }
    });
  }

  void _handleLogin(Role r, String e) {
    setState(() {
      _role = r;
      _email = e;
      _authed = true;
      _screen = ScreenKey.home;
      _stack.clear();
      _needsOnboarding = false;
    });
  }

  void _handleLogout() {
    setState(() {
      _authed = false;
      _stack.clear();
      _screen = ScreenKey.home;
      _role = Role.superAdmin;
      _email = "admin@school.edu";
    });
  }

  void _handleRoleSwitch(Role r, String e) {
    setState(() {
      _role = r;
      _email = e;
      _screen = ScreenKey.home;
      _stack.clear();
      _retrainRequired = false;
      _needsOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = _email
        .split('@')[0]
        .replaceAll(RegExp(r'[._]'), ' ')
        .split(' ')
        .map(
            (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');

    const tabScreens = [
      ScreenKey.home,
      ScreenKey.mark,
      ScreenKey.history,
      ScreenKey.notifications,
      ScreenKey.profile,
    ];

    final showBack = !tabScreens.contains(_screen);
    final showTabBar = tabScreens.contains(_screen);

    final unread = _role == Role.headOfDepartment
        ? 3
        : _role == Role.lecturer
            ? 2
            : _role == Role.superAdmin
                ? 4
                : _retrainRequired
                    ? 1
                    : 0;

    return Scaffold(
      body: Stack(
        children: [
          PhoneFrame(
            dark: widget.dark,
            child: !_authed
                ? LoginScreen(onLogin: _handleLogin)
                : _needsOnboarding
                    ? OnboardingScreen(
                        role: _role,
                        name: name,
                        email: _email,
                        onComplete: () =>
                            setState(() => _needsOnboarding = false),
                      )
                    : Column(
                        children: [
                          TopBar(
                            title: screenTitles[_screen] ?? "Attendance",
                            onBack: showBack ? _back : null,
                            onBell: _screen != ScreenKey.notifications
                                ? () => _navigate(ScreenKey.notifications)
                                : null,
                            unread: unread,
                            right: IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () =>
                                  setState(() => _drawCanvasOpen = true),
                              tooltip: "Draw / Annotate Canvas",
                            ),
                          ),
                          Expanded(
                            child: _buildCurrentScreen(name),
                          ),
                          if (showTabBar)
                            BottomNav(
                              role: _role,
                              active: _screen,
                              onChange: (k) {
                                setState(() {
                                  _stack.clear();
                                  _screen = k;
                                });
                              },
                            ),
                          InkWell(
                            onTap: () =>
                                setState(() => _roleSwitcherOpen = true),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              color: const Color(0xFF14112A),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: roleColors[_role],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text("DEV",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFB547))),
                                  const SizedBox(width: 6),
                                  Text(
                                    roleLabels[_role]!,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.5)),
                                  ),
                                  const SizedBox(width: 4),
                                  Text("·",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Colors.white.withOpacity(0.2))),
                                  const SizedBox(width: 4),
                                  Text("Switch Role ↑",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Colors.white.withOpacity(0.4))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
          if (_roleSwitcherOpen)
            RoleSwitcherModal(
              currentRole: _role,
              onSwitch: _handleRoleSwitch,
              onClose: () => setState(() => _roleSwitcherOpen = false),
            ),
          if (_drawCanvasOpen)
            DrawCanvasModal(
              onClose: () => setState(() => _drawCanvasOpen = false),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(String name) {
    switch (_screen) {
      case ScreenKey.home:
        return HomeScreen(role: _role, name: name, onNavigate: _navigate);
      case ScreenKey.mark:
        return AttendanceMarkScreen(
            onDone: () => setState(() => _screen = ScreenKey.home));
      case ScreenKey.history:
        return HistoryScreen(role: _role);
      case ScreenKey.leave:
        return const RequestScreen(kind: "Leave");
      case ScreenKey.permission:
        return const RequestScreen(kind: "Permission");
      case ScreenKey.reports:
        return const ReportsScreen();
      case ScreenKey.notifications:
        return NotificationsScreen(
            role: _role,
            retrainRequired: _retrainRequired && _role != Role.superAdmin);
      case ScreenKey.profile:
        return ProfileScreen(
          role: _role,
          name: name,
          email: _email,
          retrainRequired: _retrainRequired,
          onNavigate: _navigate,
          onLogout: _handleLogout,
        );
      case ScreenKey.settings:
        return SettingsScreen(
          dark: widget.dark,
          onToggleDark: widget.onToggleDark,
          retrainRequired: _retrainRequired,
          onRetrainComplete: () => setState(() => _retrainRequired = false),
          isSuperAdmin: _role == Role.superAdmin,
        );
      case ScreenKey.users:
        return UserManagementScreen(
          isSuperAdmin: _role == Role.superAdmin,
          retrainRequested: _retrainRequired,
          onRequestRetrain: () => setState(() => _retrainRequired = true),
        );
      case ScreenKey.faceCapture:
        return FaceCaptureScreen(
          onDone: () {
            setState(() => _retrainRequired = false);
            _back();
          },
        );
      case ScreenKey.backup:
        return const BackupScreen();
      case ScreenKey.attendanceDashboard:
        return AttendanceDashboardScreen(role: _role);
      case ScreenKey.classAttendance:
        return ClassAttendanceScreen(role: _role);
    }
  }
}
