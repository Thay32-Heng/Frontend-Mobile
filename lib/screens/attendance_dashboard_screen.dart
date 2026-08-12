import 'package:flutter/material.dart';
import '../types.dart';
import '../mock_data.dart';

class AttendanceDashboardScreen extends StatefulWidget {
  final Role role;

  const AttendanceDashboardScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<AttendanceDashboardScreen> createState() => _AttendanceDashboardScreenState();
}

class _AttendanceDashboardScreenState extends State<AttendanceDashboardScreen> {
  void _showDrillDialog(String title, List<UserHistoryItem> list, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: isDark ? const Color(0xFF201B3E) : Colors.white,
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E1B4B))),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final u = list[index];
              return ListTile(
                leading: CircleAvatar(backgroundColor: const Color(0xFF5B32E8), child: Text(u.user[0], style: const TextStyle(color: Colors.white))),
                title: Text(u.user, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E1B4B))),
                subtitle: Text(u.role, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA))),
                trailing: Text(u.id, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA))),
              );
            },
          ),
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
    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final subtitleColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);
    final inputBgColor = isDark ? const Color(0xFF2E2657) : const Color(0xFFF7F5FF);

    final isSuperAdmin = widget.role == Role.superAdmin;
    final List<UserHistoryItem> allUsers = isSuperAdmin
        ? stakeholderRoles.expand((r) => usersByRoleData[r] ?? <UserHistoryItem>[]).toList()
        : [...(usersByRoleData["Student"] ?? <UserHistoryItem>[]), ...(usersByRoleData["Lecturer"] ?? <UserHistoryItem>[])];

    final total = allUsers.length;
    final presentUsers = allUsers.where((u) => u.records.any((r) => r.date == "2026-05-29" && r.status == "Present")).toList();
    final lateUsers = allUsers.where((u) => u.records.any((r) => r.date == "2026-05-29" && r.status == "Late")).toList();
    final absentUsers = allUsers.where((u) => u.records.any((r) => r.date == "2026-05-29" && r.status == "Absent")).toList();
    final leaveUsers = allUsers.where((u) => u.records.any((r) => r.date == "2026-05-29" && r.status == "Leave")).toList();

    final attended = presentUsers.length + lateUsers.length;
    final rate = total == 0 ? 0 : ((attended / total) * 100).round();

    final gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF14112A), const Color(0xFF191535), const Color(0xFF211A42)]
            : [const Color(0xFFE4E0FF), const Color(0xFFEFE8FF), const Color(0xFFFAE8F4)],
      ),
    );

    return Container(
      decoration: gradientDecoration,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Hero Header Banner
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Today · Tue, Aug 11", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bar_chart_rounded, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text("$rate%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text("Attendance Overview", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(isSuperAdmin ? "All Stakeholders" : "Computer Science Dept.", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(value: 1.0, backgroundColor: Colors.white24, color: Colors.white, minHeight: 6),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$attended / $total present", style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const Text("▲ 89% vs yesterday", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. 4 Vertical Metric Stat Cards
          Row(
            children: [
              _buildStatCard("Present", "${presentUsers.length}", const Color(0xFF05CD99), isDark ? const Color(0xFF1E3A32) : const Color(0xFFE6F9F3), Icons.check_circle_outline_rounded, cardColor, subtitleColor, () => _showDrillDialog("Present Today", presentUsers, isDark)),
              _buildStatCard("Late", "${lateUsers.length}", const Color(0xFFFFB547), isDark ? const Color(0xFF3E321E) : const Color(0xFFFFF8E7), Icons.access_time_rounded, cardColor, subtitleColor, () => _showDrillDialog("Late Today", lateUsers, isDark)),
              _buildStatCard("Absent", "${absentUsers.length}", const Color(0xFFEE5D50), isDark ? const Color(0xFF3E1F28) : const Color(0xFFFFF0F0), Icons.error_outline_rounded, cardColor, subtitleColor, () => _showDrillDialog("Absent Today", absentUsers, isDark)),
              _buildStatCard("Leave", "${leaveUsers.length}", const Color(0xFF63B3ED), isDark ? const Color(0xFF1F2F44) : const Color(0xFFEBF5FF), Icons.calendar_today_rounded, cardColor, subtitleColor, () => _showDrillDialog("On Leave Today", leaveUsers, isDark)),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Weekly Trend Chart Card
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
                          Text("Weekly Trend", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Avg ", style: TextStyle(fontSize: 12, color: subtitleColor)),
                          const Text("87%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTrendDay("92%", "Mon", subtitleColor),
                      _buildTrendDay("88%", "Tue", subtitleColor),
                      _buildTrendDay("95%", "Wed", subtitleColor),
                      _buildTrendDay("81%", "Thu", subtitleColor),
                      _buildTrendDay("90%", "Fri", subtitleColor),
                      _buildTrendDay("76%", "Sat", subtitleColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. By Role Card
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
                      const Icon(Icons.people_outline_rounded, color: Color(0xFF8B5BF6), size: 20),
                      const SizedBox(width: 8),
                      Text("By Role", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...["Student", "Lecturer", "Class Monitor", "Assistant", "Staff"].map((r) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r, style: TextStyle(fontSize: 12, color: titleColor)),
                              const Text("100%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF05CD99))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(value: 1.0, backgroundColor: isDark ? const Color(0xFF2D255A) : const Color(0xFFEBF0FF), color: const Color(0xFF05CD99), minHeight: 6),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 5. Month Summary Card
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
                      const Icon(Icons.calendar_today_rounded, color: Color(0xFF8B5BF6), size: 20),
                      const SizedBox(width: 8),
                      Text("Month Summary — May 2026", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildMonthSummaryBox("22", "Days Tracked", "school days", inputBgColor, titleColor, subtitleColor),
                      _buildMonthSummaryBox("87%", "Avg Rate", "attendance", inputBgColor, titleColor, subtitleColor),
                      _buildMonthSummaryBox("3", "Incidents", "alerts flagged", inputBgColor, titleColor, subtitleColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, Color bg, IconData icon, Color cardColor, Color subtitleColor, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Card(
            elevation: 0,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 2),
                  Text(label, style: TextStyle(fontSize: 11, color: subtitleColor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendDay(String pct, String day, Color subtitleColor) {
    return Column(
      children: [
        Text(pct, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
        const SizedBox(height: 6),
        Text(day, style: TextStyle(fontSize: 11, color: subtitleColor)),
      ],
    );
  }

  Widget _buildMonthSummaryBox(String val, String title, String sub, Color inputBgColor, Color titleColor, Color subtitleColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: inputBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: titleColor)),
            Text(sub, style: TextStyle(fontSize: 9, color: subtitleColor)),
          ],
        ),
      ),
    );
  }
}
