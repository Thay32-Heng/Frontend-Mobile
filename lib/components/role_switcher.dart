import 'package:flutter/material.dart';
import '../types.dart';

class RoleEntry {
  final Role role;
  final String label;
  final String email;
  final Color dot;
  final int pages;

  RoleEntry({
    required this.role,
    required this.label,
    required this.email,
    required this.dot,
    required this.pages,
  });
}

final List<RoleEntry> roleEntries = [
  RoleEntry(role: Role.superAdmin, label: "Super Admin", email: "admin@school.edu", dot: const Color(0xFF7551FF), pages: 11),
  RoleEntry(role: Role.headOfDepartment, label: "Head of Dept", email: "hod@school.edu", dot: const Color(0xFF4A90D9), pages: 8),
  RoleEntry(role: Role.lecturer, label: "Lecturer", email: "lecturer@school.edu", dot: const Color(0xFF9B59B6), pages: 7),
  RoleEntry(role: Role.classMonitor, label: "Class Monitor", email: "monitor@school.edu", dot: const Color(0xFFF39C12), pages: 6),
  RoleEntry(role: Role.assistant, label: "Assistant", email: "assistant@school.edu", dot: const Color(0xFF1ABC9C), pages: 7),
  RoleEntry(role: Role.staff, label: "Staff", email: "staff@school.edu", dot: const Color(0xFF95A5A6), pages: 5),
  RoleEntry(role: Role.student, label: "Student", email: "student@school.edu", dot: const Color(0xFF2ECC71), pages: 4),
];

class PageCategory {
  final String title;
  final List<String> pages;
  PageCategory(this.title, this.pages);
}

final Map<Role, List<PageCategory>> rolePagesMap = {
  Role.superAdmin: [
    PageCategory("MAIN", ["Dashboard"]),
    PageCategory("ATTENDANCE", ["Face Capture", "Att. Dashboard", "Att. Marking", "Class Mgmt", "Class Attendance", "Att. History"]),
    PageCategory("MANAGEMENT", ["Request", "Report", "User Mgmt"]),
    PageCategory("SYSTEM", ["Settings"]),
  ],
  Role.headOfDepartment: [
    PageCategory("MAIN", ["Dashboard"]),
    PageCategory("ATTENDANCE", ["Face Capture", "Att. Dashboard", "Att. History"]),
    PageCategory("MANAGEMENT", ["Request", "Report"]),
    PageCategory("SYSTEM", ["Settings"]),
  ],
  Role.lecturer: [
    PageCategory("MAIN", ["Dashboard"]),
    PageCategory("ATTENDANCE", ["Face Capture", "Att. Marking", "Class Attendance", "Att. History"]),
    PageCategory("MANAGEMENT", ["Request", "Report"]),
  ],
  Role.classMonitor: [
    PageCategory("MAIN", ["Dashboard"]),
    PageCategory("ATTENDANCE", ["Face Capture", "Class Attendance", "Att. History"]),
    PageCategory("MANAGEMENT", ["Request", "Report"]),
  ],
  Role.assistant: [
    PageCategory("MAIN", ["Dashboard"]),
    PageCategory("ATTENDANCE", ["Face Capture", "Att. Dashboard", "Att. History"]),
    PageCategory("MANAGEMENT", ["Request", "Report"]),
    PageCategory("SYSTEM", ["Settings"]),
  ],
  Role.staff: [
    PageCategory("MAIN", ["Dashboard"]),
    PageCategory("ATTENDANCE", ["Face Capture", "Att. History"]),
    PageCategory("MANAGEMENT", ["Request"]),
    PageCategory("SYSTEM", ["Settings"]),
  ],
  Role.student: [
    PageCategory("MAIN", ["Dashboard"]),
    PageCategory("ATTENDANCE", ["Face Capture", "Att. History"]),
    PageCategory("MANAGEMENT", ["Request"]),
  ],
};

class RoleSwitcherModal extends StatefulWidget {
  final Role currentRole;
  final Function(Role role, String email) onSwitch;
  final VoidCallback onClose;

  const RoleSwitcherModal({
    Key? key,
    required this.currentRole,
    required this.onSwitch,
    required this.onClose,
  }) : super(key: key);

  @override
  State<RoleSwitcherModal> createState() => _RoleSwitcherModalState();
}

class _RoleSwitcherModalState extends State<RoleSwitcherModal> {
  late Role preview;

  @override
  void initState() {
    super.initState();
    preview = widget.currentRole;
  }

  @override
  Widget build(BuildContext context) {
    final previewEntry = roleEntries.firstWhere((r) => r.role == preview);
    final categories = rolePagesMap[preview] ?? [];
    final totalPages = categories.fold(0, (sum, cat) => sum + cat.pages.length);
    final canSwitch = preview != widget.currentRole;

    return Container(
      color: const Color(0xCC0A081E),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 380,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF14112A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB547),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.bolt, size: 12, color: Color(0xFF1B2559)),
                          SizedBox(width: 4),
                          Text(
                            "DEV ONLY",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Role Preview · switch role anytime",
                        style: TextStyle(fontSize: 11, color: Colors.white54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Colors.white38),
                      onPressed: widget.onClose,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    ),
                  ],
                ),
              ),

              // Two columns body
              Expanded(
                child: Row(
                  children: [
                    // Left Role List
                    Container(
                      width: 170,
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.06))),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
                            child: Text(
                              "SWITCH ROLE",
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF8F9BBA), letterSpacing: 1.2),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: roleEntries.length,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (context, index) {
                                final r = roleEntries[index];
                                final isActive = r.role == widget.currentRole;
                                final isPreviewed = r.role == preview;

                                return InkWell(
                                  onTap: () => setState(() => preview = r.role),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                      color: isPreviewed ? const Color(0x2E7551FF) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isPreviewed ? const Color(0x737551FF) : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 8, height: 8,
                                              decoration: BoxDecoration(color: r.dot, shape: BoxShape.circle),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                r.label,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: isPreviewed ? Colors.white : Colors.white70,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          r.email,
                                          style: const TextStyle(fontSize: 9, color: Colors.white38),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              "${r.pages} pages",
                                              style: TextStyle(fontSize: 9, color: isPreviewed ? Colors.white54 : const Color(0xFF8F9BBA)),
                                            ),
                                            if (isActive) ...[
                                              const SizedBox(width: 4),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x477551FF),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  "Active",
                                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFFA78BFA)),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right Pages Breakdown
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                            child: Text(
                              "CURRENT: ${previewEntry.label.toUpperCase()}",
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF8F9BBA), letterSpacing: 1.1),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              children: categories.map((cat) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 4),
                                      child: Text(
                                        cat.title,
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF4318FF), letterSpacing: 1.0),
                                      ),
                                    ),
                                    ...cat.pages.map((p) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 6, height: 6,
                                            decoration: const BoxDecoration(color: Color(0xFF39B8FF), shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              p,
                                              style: const TextStyle(fontSize: 11, color: Colors.white70),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Accessible pages", style: TextStyle(fontSize: 10, color: Color(0xFF8F9BBA))),
                                Text(
                                  "$totalPages / 11",
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7551FF)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Switch Button Footer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
                ),
                child: Column(
                  children: [
                    if (canSwitch)
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4318FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            widget.onSwitch(preview, previewEntry.email);
                            widget.onClose();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Switch to ${previewEntry.label}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, size: 18, color: Colors.white),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Text(
                          "Currently viewing as ${previewEntry.label}",
                          style: const TextStyle(fontSize: 12, color: Colors.white38),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
