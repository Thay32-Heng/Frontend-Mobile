import 'package:flutter/material.dart';
import '../types.dart';

class HomeScreen extends StatefulWidget {
  final Role role;
  final String name;
  final Function(ScreenKey key) onNavigate;

  const HomeScreen({
    Key? key,
    required this.role,
    required this.name,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning,";
    if (hour < 17) return "Good Afternoon,";
    return "Good Evening,";
  }

  List<Map<String, dynamic>> _getQuickActions() {
    switch (widget.role) {
      case Role.superAdmin:
        return [
          {"key": ScreenKey.attendanceDashboard, "label": "Att. DB", "icon": Icons.bar_chart_rounded},
          {"key": ScreenKey.users, "label": "Users", "icon": Icons.people_outline_rounded},
          {"key": ScreenKey.reports, "label": "Reports", "icon": Icons.assignment_outlined},
          {"key": ScreenKey.settings, "label": "Settings", "icon": Icons.settings_outlined},
        ];
      case Role.classMonitor:
        return [
          {"key": ScreenKey.classAttendance, "label": "Attendance", "icon": Icons.checklist_rounded},
          {"key": ScreenKey.mark, "label": "Scan", "icon": Icons.center_focus_strong_rounded},
          {"key": ScreenKey.history, "label": "Track", "icon": Icons.description_outlined},
          {"key": ScreenKey.leave, "label": "Leave", "icon": Icons.calendar_today_rounded},
        ];
      case Role.assistant:
        return [
          {"key": ScreenKey.attendanceDashboard, "label": "Att. DB", "icon": Icons.bar_chart_rounded},
          {"key": ScreenKey.mark, "label": "Scan", "icon": Icons.center_focus_strong_rounded},
          {"key": ScreenKey.notifications, "label": "Requests", "icon": Icons.inbox_outlined},
          {"key": ScreenKey.reports, "label": "Reports", "icon": Icons.assignment_outlined},
        ];
      case Role.headOfDepartment:
        return [
          {"key": ScreenKey.attendanceDashboard, "label": "Att. DB", "icon": Icons.bar_chart_rounded},
          {"key": ScreenKey.notifications, "label": "Approve", "icon": Icons.inbox_outlined},
          {"key": ScreenKey.reports, "label": "Reports", "icon": Icons.assignment_outlined},
          {"key": ScreenKey.history, "label": "History", "icon": Icons.description_outlined},
        ];
      case Role.lecturer:
        return [
          {"key": ScreenKey.classAttendance, "label": "Roll Call", "icon": Icons.checklist_rounded},
          {"key": ScreenKey.mark, "label": "Scan", "icon": Icons.center_focus_strong_rounded},
          {"key": ScreenKey.notifications, "label": "Approve", "icon": Icons.inbox_outlined},
          {"key": ScreenKey.leave, "label": "Leave", "icon": Icons.calendar_today_rounded},
        ];
      default:
        return [
          {"key": ScreenKey.mark, "label": "Scan", "icon": Icons.center_focus_strong_rounded},
          {"key": ScreenKey.leave, "label": "Leave", "icon": Icons.calendar_today_rounded},
          {"key": ScreenKey.permission, "label": "Permission", "icon": Icons.assignment_outlined},
          {"key": ScreenKey.reports, "label": "Reports", "icon": Icons.assignment_outlined},
        ];
    }
  }

  void _showModal(String title, Widget content, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: isDark ? const Color(0xFF201B3E) : Colors.white,
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E1B4B))),
        content: SizedBox(
          width: double.maxFinite,
          child: content,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Color(0xFF8B5BF6), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quickActions = _getQuickActions();
    final isSuperAdmin = widget.role == Role.superAdmin;
    final isClassMonitor = widget.role == Role.classMonitor;
    final isAssistant = widget.role == Role.assistant;
    final isHoD = widget.role == Role.headOfDepartment;
    final isLecturer = widget.role == Role.lecturer;

    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final subtitleColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);
    final pillBgColor = isDark ? const Color(0xFF2E2657) : const Color(0xFFF5F4FF);
    final pillBorderColor = isDark ? const Color(0xFF3B326B) : const Color(0xFFE4E0FF);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF14112A), const Color(0xFF191535), const Color(0xFF211A42)]
              : [const Color(0xFFE4E0FF), const Color(0xFFEFE8FF), const Color(0xFFFAE8F4)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Greeting Hero Card (Vibrant Purple Gradient)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5B32E8), Color(0xFF6E40F3), Color(0xFF8B5BF6)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5B32E8).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00E676),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            isSuperAdmin ? "All Systems Operational" : "Checked In · On Time",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Text(_getGreeting(), style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 2),
                Text(widget.name.split(' ')[0], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 2),
                Text("Tuesday, August 11, 2026 · ${roleLabels[widget.role]}", style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.75))),
                const SizedBox(height: 18),

                // Quick Action Buttons Row (Rounded Pills)
                Row(
                  children: quickActions.map((act) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => widget.onNavigate(act["key"] as ScreenKey),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.12)),
                            ),
                            child: Column(
                              children: [
                                Icon(act["icon"] as IconData, color: Colors.white, size: 20),
                                const SizedBox(height: 5),
                                Text(act["label"].toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Role-specific Dashboards
          if (isSuperAdmin) _buildSuperAdminView(isDark, cardColor, titleColor, subtitleColor, pillBgColor, pillBorderColor),
          if (isHoD) _buildHoDView(cardColor, titleColor, subtitleColor),
          if (isLecturer) _buildLecturerView(cardColor, titleColor, subtitleColor),
          if (isClassMonitor) _buildClassMonitorView(cardColor, titleColor, subtitleColor),
          if (isAssistant) _buildAssistantView(cardColor, titleColor, subtitleColor),

          if (!isSuperAdmin && !isHoD && !isLecturer && !isClassMonitor && !isAssistant) ...[
            Row(
              children: [
                _buildStatCard("Present", "42", const Color(0xFF05CD99), cardColor, subtitleColor),
                _buildStatCard("Late", "3", const Color(0xFFFFB547), cardColor, subtitleColor),
                _buildStatCard("Absent", "2", const Color(0xFFEE5D50), cardColor, subtitleColor),
              ],
            ),
            const SizedBox(height: 14),
            Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Semester Attendance", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor)),
                        const Text("87%", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(value: 0.87, backgroundColor: Color(0xFF2D255A), color: Color(0xFF8B5BF6), minHeight: 6),
                    const SizedBox(height: 6),
                    Text("Minimum requirement: 80%", style: TextStyle(fontSize: 11, color: subtitleColor)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuperAdminView(bool isDark, Color cardColor, Color titleColor, Color subtitleColor, Color pillBgColor, Color pillBorderColor) {
    return Column(
      children: [
        // 1. System Health Card
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.show_chart_rounded, color: Color(0xFF8B5BF6), size: 20),
                        const SizedBox(width: 8),
                        Text("System Health", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFE6F9F3).withOpacity(isDark ? 0.2 : 1.0), borderRadius: BorderRadius.circular(14)),
                      child: const Text("Operational", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF05CD99))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [Text("11", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: titleColor)), const SizedBox(height: 2), Text("Users", style: TextStyle(fontSize: 11, color: subtitleColor))]),
                    Column(children: [Text("9/11", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: titleColor)), const SizedBox(height: 2), Text("Faces", style: TextStyle(fontSize: 11, color: subtitleColor))]),
                    InkWell(
                      onTap: () => _showModal("Missing Face Data (2 Users)", Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildUserTile("Kim Bopha", "Staff · F-009", titleColor, subtitleColor),
                          _buildUserTile("Noun Sopheak", "Staff · F-010", titleColor, subtitleColor),
                        ],
                      ), isDark),
                      child: const Column(children: [Text("2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFB547))), SizedBox(height: 2), Text("Missing →", style: TextStyle(fontSize: 11, color: Color(0xFFFFB547), fontWeight: FontWeight.bold))]),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: isDark ? const Color(0xFF2F2853) : Colors.grey.shade200),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.sd_storage_outlined, size: 16, color: subtitleColor),
                    const SizedBox(width: 8),
                    Text("Last backup: 2026-05-29 06:00", style: TextStyle(fontSize: 12, color: subtitleColor)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 2. Today's Attendance Overview Card
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today's Attendance Overview", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                    Row(
                      children: [
                        Text("Rate ", style: TextStyle(fontSize: 11, color: subtitleColor)),
                        const Text("100%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF05CD99))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: 1.0, backgroundColor: isDark ? const Color(0xFF2D255A) : const Color(0xFFEBF0FF), color: const Color(0xFF05CD99), minHeight: 6),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInteractiveMiniTile("Present", "10", const Color(0xFF05CD99), subtitleColor, () => _showModal("Present Today (10)", Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildUserTile("Sok Pisey", "Student · 07:42 AM", titleColor, subtitleColor),
                        _buildUserTile("Chea Mengly", "Student · 07:45 AM", titleColor, subtitleColor),
                        _buildUserTile("Chan Dara", "Lecturer · 07:30 AM", titleColor, subtitleColor),
                      ],
                    ), isDark)),
                    _buildInteractiveMiniTile("Late", "1", const Color(0xFFFFB547), subtitleColor, () => _showModal("Late Today (1)", Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildUserTile("Pich Sambath", "Student · 08:18 AM", titleColor, subtitleColor),
                      ],
                    ), isDark)),
                    _buildInteractiveMiniTile("Absent", "0", const Color(0xFFEE5D50), subtitleColor, () => _showModal("Absent Today (0)", Text("No absent users today!", style: TextStyle(color: titleColor)), isDark)),
                    _buildInteractiveMiniTile("Leave", "0", const Color(0xFF63B3ED), subtitleColor, () => _showModal("On Leave Today (0)", Text("No users on leave today!", style: TextStyle(color: titleColor)), isDark)),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text("11/11 attended · tap a number to see who", style: TextStyle(fontSize: 11, color: subtitleColor)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 3. Critical Alerts Card
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Color(0xFFEE5D50), size: 20),
                        const SizedBox(width: 8),
                        Text("Critical Alerts", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                      ],
                    ),
                    InkWell(
                      onTap: () => widget.onNavigate(ScreenKey.notifications),
                      child: const Row(
                        children: [
                          Text("View all", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                          SizedBox(width: 2),
                          Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF8B5BF6)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                _buildAlertPillRow("2 users missing face data", "Notify Users", const Color(0xFFEE5D50), Icons.shield_outlined, titleColor, isDark, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Retrain notification sent to users")));
                }),
                _buildAlertPillRow("1 failed scan repeated 5 times (Pich Sambath)", "Review", const Color(0xFFEE5D50), Icons.error_outline, titleColor, isDark, () {
                  widget.onNavigate(ScreenKey.notifications);
                }),
                _buildAlertPillRow("Backup older than 24h on secondary node", "Run Backup", const Color(0xFFFFB547), Icons.warning_amber_rounded, titleColor, isDark, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Backup initiated on secondary node")));
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 4. Pending Requests Card
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inbox_rounded, color: Color(0xFF8B5BF6), size: 20),
                        const SizedBox(width: 8),
                        Text("Pending Requests", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                      ],
                    ),
                    InkWell(
                      onTap: () => widget.onNavigate(ScreenKey.notifications),
                      child: const Row(
                        children: [
                          Text("View all", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                          SizedBox(width: 2),
                          Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF8B5BF6)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildPrioBox("High", "2", "Face Retrain", const Color(0xFFEE5D50), subtitleColor, isDark),
                    _buildPrioBox("Med", "2", "Leave", const Color(0xFFFFB547), subtitleColor, isDark),
                    _buildPrioBox("Low", "2", "Permission", const Color(0xFF63B3ED), subtitleColor, isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 5. System Actions Grid Card
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.settings_outlined, color: Color(0xFF8B5BF6), size: 20),
                    const SizedBox(width: 8),
                    Text("System Actions", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                  ],
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildPillActionButton("Backup Now", Icons.file_download_outlined, pillBgColor, pillBorderColor, () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Backup started")));
                    }),
                    _buildPillActionButton("Notify All", Icons.notifications_none_rounded, pillBgColor, pillBorderColor, () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Broadcast alert sent to all stakeholders")));
                    }),
                    _buildPillActionButton("Export Report", Icons.file_present_outlined, pillBgColor, pillBorderColor, () {
                      widget.onNavigate(ScreenKey.reports);
                    }),
                    _buildPillActionButton("Restore", Icons.refresh_rounded, pillBgColor, pillBorderColor, () {
                      widget.onNavigate(ScreenKey.backup);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHoDView(Color cardColor, Color titleColor, Color subtitleColor) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Department Overview", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                Text("Computer Science Dept.", style: TextStyle(fontSize: 11, color: subtitleColor)),
                const SizedBox(height: 10),
                const LinearProgressIndicator(value: 0.92, backgroundColor: Color(0xFF2D255A), color: Color(0xFF05CD99), minHeight: 6),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLecturerView(Color cardColor, Color titleColor, Color subtitleColor) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Sessions", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Database Systems", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: titleColor)),
                  subtitle: Text("07:30–09:00 · B201", style: TextStyle(fontSize: 11, color: subtitleColor)),
                  trailing: const Text("3/3 present", style: TextStyle(color: Color(0xFF05CD99), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassMonitorView(Color cardColor, Color titleColor, Color subtitleColor) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Class Attendance", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                Text("CS Year 2", style: TextStyle(fontSize: 11, color: subtitleColor)),
                const SizedBox(height: 10),
                const LinearProgressIndicator(value: 0.88, backgroundColor: Color(0xFF2D255A), color: Color(0xFF05CD99), minHeight: 6),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssistantView(Color cardColor, Color titleColor, Color subtitleColor) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Flagged Records", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Sok Pisey", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: titleColor)),
                  subtitle: Text("Duplicate scan · 07:42", style: TextStyle(fontSize: 11, color: subtitleColor)),
                  trailing: const Text("Review", style: TextStyle(color: Color(0xFF8B5BF6), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, Color cardColor, Color subtitleColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Card(
          elevation: 0,
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 2),
                Text(label, style: TextStyle(fontSize: 11, color: subtitleColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveMiniTile(String label, String value, Color color, Color subtitleColor, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: subtitleColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertPillRow(String text, String btnLabel, Color accentColor, IconData icon, Color titleColor, bool isDark, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(isDark ? 0.12 : 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accentColor.withOpacity(0.18)),
        ),
        child: Row(
          children: [
            Icon(icon, color: accentColor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: titleColor),
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E2657) : const Color(0xFFF0EEFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  btnLabel,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioBox(String priority, String count, String label, Color accentColor, Color subtitleColor, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2B2452) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? const Color(0xFF3B326B) : Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accentColor)),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(priority, style: TextStyle(color: accentColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: subtitleColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildPillActionButton(String label, IconData icon, Color pillBgColor, Color pillBorderColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: pillBgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: pillBorderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF8B5BF6)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(String name, String sub, Color titleColor, Color subtitleColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: const Color(0xFF5B32E8), child: Text(getInitials(name), style: const TextStyle(color: Colors.white, fontSize: 12))),
      title: Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: titleColor)),
      subtitle: Text(sub, style: TextStyle(fontSize: 11, color: subtitleColor)),
    );
  }
}
