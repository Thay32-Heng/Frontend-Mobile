import 'package:flutter/material.dart';
import '../core/types.dart';
import '../core/mock_data.dart';

class HistoryScreen extends StatefulWidget {
  final Role role;

  const HistoryScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = "all";
  String? _selectedRole;
  UserHistoryItem? _selectedUser;

  Widget _buildStatusTabs(bool isDark, Color cardColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: ["all", "present", "late", "absent", "leave"].map((tab) {
          final isActive = _filter == tab;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _filter = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? (isDark ? const Color(0xFF2E2657) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isActive
                      ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                      : [],
                ),
                child: Center(
                  child: Text(
                    tab[0].toUpperCase() + tab.substring(1),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? const Color(0xFF8B5BF6) : subtitleColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecordCard(AttendanceRecordItem r, Color cardColor,
      Color titleColor, Color subtitleColor) {
    Color badgeBg = const Color(0x1A05CD99);
    Color badgeColor = const Color(0xFF05CD99);
    if (r.status == "Late") {
      badgeBg = const Color(0x1AFFB547);
      badgeColor = const Color(0xFFFFB547);
    } else if (r.status == "Absent") {
      badgeBg = const Color(0x1AEE5D50);
      badgeColor = const Color(0xFFEE5D50);
    } else if (r.status == "Leave") {
      badgeBg = const Color(0x1A63B3ED);
      badgeColor = const Color(0xFF63B3ED);
    }

    final dt = DateTime.tryParse(r.date) ?? DateTime.now();

    return Card(
      elevation: 0,
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  Text(
                    [
                      "Jan",
                      "Feb",
                      "Mar",
                      "Apr",
                      "May",
                      "Jun",
                      "Jul",
                      "Aug",
                      "Sep",
                      "Oct",
                      "Nov",
                      "Dec"
                    ][dt.month - 1],
                    style: TextStyle(fontSize: 11, color: subtitleColor),
                  ),
                  Text(
                    "${dt.day}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${r.checkIn != null ? 'In ' + r.checkIn! : '—'} · ${r.checkOut != null ? 'Out ' + r.checkOut! : '—'}",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                  Text(
                    [
                      "Monday",
                      "Tuesday",
                      "Wednesday",
                      "Thursday",
                      "Friday",
                      "Saturday",
                      "Sunday"
                    ][dt.weekday - 1],
                    style: TextStyle(fontSize: 11, color: subtitleColor),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: badgeBg, borderRadius: BorderRadius.circular(20)),
              child: Text(
                r.status,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final subtitleColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);
    final initialBgColor =
        isDark ? const Color(0xFF2E2657) : const Color(0xFFF0EEFF);

    final gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                const Color(0xFF14112A),
                const Color(0xFF191535),
                const Color(0xFF211A42)
              ]
            : [
                const Color(0xFFE4E0FF),
                const Color(0xFFEFE8FF),
                const Color(0xFFFAE8F4)
              ],
      ),
    );

    // SuperAdmin Level 3: User Records
    if (widget.role == Role.superAdmin && _selectedUser != null) {
      final items = _selectedUser!.records
          .where((r) => _filter == "all" || r.status.toLowerCase() == _filter)
          .toList();

      return Container(
        decoration: gradientDecoration,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextButton.icon(
              icon: const Icon(Icons.chevron_left, size: 18),
              label: Text("Back to ${_selectedUser!.role}s",
                  style: const TextStyle(color: Color(0xFF8B5BF6))),
              onPressed: () => setState(() => _selectedUser = null),
            ),
            Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF5B32E8),
                      child: Text(getInitials(_selectedUser!.user),
                          style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedUser!.user,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: titleColor)),
                          Text("${_selectedUser!.role} · ${_selectedUser!.id}",
                              style: TextStyle(
                                  fontSize: 11, color: subtitleColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusTabs(isDark, cardColor, subtitleColor),
            const SizedBox(height: 12),
            ...items
                .map((r) =>
                    _buildRecordCard(r, cardColor, titleColor, subtitleColor))
                .toList(),
          ],
        ),
      );
    }

    // SuperAdmin Level 2: User List for selected role
    if (widget.role == Role.superAdmin && _selectedRole != null) {
      final users = usersByRoleData[_selectedRole] ?? [];

      return Container(
        decoration: gradientDecoration,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextButton.icon(
              icon: const Icon(Icons.chevron_left, size: 18),
              label: const Text("Back to stakeholders",
                  style: TextStyle(color: Color(0xFF8B5BF6))),
              onPressed: () => setState(() => _selectedRole = null),
            ),
            Text("$_selectedRole (${users.length})",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: titleColor)),
            const SizedBox(height: 12),
            ...users.map((u) {
              final presentCount =
                  u.records.where((r) => r.status == "Present").length;
              return Card(
                elevation: 0,
                color: cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF5B32E8),
                    child: Text(getInitials(u.user),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  title: Text(u.user,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  subtitle: Text(
                      "${u.id} · $presentCount/${u.records.length} present",
                      style: TextStyle(fontSize: 11, color: subtitleColor)),
                  trailing:
                      Icon(Icons.chevron_right, size: 18, color: subtitleColor),
                  onTap: () => setState(() => _selectedUser = u),
                ),
              );
            }).toList(),
          ],
        ),
      );
    }

    // SuperAdmin Level 1: Stakeholder Roles List
    if (widget.role == Role.superAdmin) {
      return Container(
        decoration: gradientDecoration,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text("Viewing as SuperAdmin · choose a stakeholder",
                  style: TextStyle(fontSize: 11, color: subtitleColor)),
            ),
            ...stakeholderRoles.map((r) {
              final users = usersByRoleData[r] ?? [];
              return Card(
                elevation: 0,
                color: cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => setState(() => _selectedRole = r),
                  borderRadius: BorderRadius.circular(28),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Large Centered Square Icon Badge
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: initialBgColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              getInitials(r),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B5BF6)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Role Title
                        Text(
                          r,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: titleColor),
                        ),
                        const SizedBox(height: 2),

                        // Subtitle User Count
                        Text(
                          "${users.length} user${users.length == 1 ? '' : 's'}",
                          style: TextStyle(fontSize: 12, color: subtitleColor),
                        ),
                        const SizedBox(height: 14),

                        // Centered Chevron Indicator
                        Icon(Icons.chevron_right_rounded,
                            size: 20, color: subtitleColor),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    }

    // Regular User History
    final items = mockHistoryData
        .where((r) => _filter == "all" || r.status.toLowerCase() == _filter)
        .toList();

    return Container(
      decoration: gradientDecoration,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusTabs(isDark, cardColor, subtitleColor),
          const SizedBox(height: 14),
          ...items
              .map((r) =>
                  _buildRecordCard(r, cardColor, titleColor, subtitleColor))
              .toList(),
        ],
      ),
    );
  }
}
