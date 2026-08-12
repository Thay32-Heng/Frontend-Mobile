import 'package:flutter/material.dart';
import '../types.dart';
import '../mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  final bool retrainRequired;
  final Role role;

  const NotificationsScreen({
    Key? key,
    this.retrainRequired = false,
    this.role = Role.student,
  }) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late String _tab;
  late List<ApprovalRequestItem> _requests;

  @override
  void initState() {
    super.initState();
    final isApprover = widget.role == Role.headOfDepartment || widget.role == Role.lecturer;
    _tab = isApprover ? "inbox" : "notifications";
    _requests = widget.role == Role.headOfDepartment ? List.from(hodRequestsData) : List.from(lecturerRequestsData);
  }

  void _handleDecision(String id, RequestStatus decision) {
    setState(() {
      final index = _requests.indexWhere((r) => r.id == id);
      if (index != -1) {
        _requests[index].status = decision;
      }
    });

    final isHoD = widget.role == Role.headOfDepartment;
    if (decision == RequestStatus.approved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isHoD ? "$id approved" : "$id recommended for approval — forwarded to HoD"),
          backgroundColor: const Color(0xFF05CD99),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$id rejected"), backgroundColor: const Color(0xFFEE5D50)),
      );
    }
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Card(
      elevation: 0,
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: isUnread
            ? const BorderSide(color: Color(0x408B5BF6), width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Left Rounded Icon Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),

                // Main Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor),
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(fontSize: 11, color: subtitleColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: subtitleColor, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Centered Unread Dot
            if (isUnread) ...[
              const SizedBox(height: 12),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5BF6),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isApprover = widget.role == Role.headOfDepartment || widget.role == Role.lecturer;
    final isSuperAdmin = widget.role == Role.superAdmin;
    final pending = _requests.where((r) => r.status == RequestStatus.pending).toList();

    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final subtitleColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);

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
      child: Column(
        children: [
          // Tab bar for approvers
          if (isApprover)
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF201B3E) : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _tab = "inbox"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _tab == "inbox" ? (isDark ? const Color(0xFF2E2657) : Colors.white) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _tab == "inbox" ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Approval Inbox",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _tab == "inbox" ? const Color(0xFF8B5BF6) : subtitleColor,
                                ),
                              ),
                              if (pending.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: const BoxDecoration(color: Color(0xFF8B5BF6), shape: BoxShape.circle),
                                  child: Text("${pending.length}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _tab = "notifications"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _tab == "notifications" ? (isDark ? const Color(0xFF2E2657) : Colors.white) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _tab == "notifications" ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                          ),
                          child: Center(
                            child: Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _tab == "notifications" ? const Color(0xFF8B5BF6) : subtitleColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Approval Inbox ──
                if (isApprover && _tab == "inbox") ...[
                  if (pending.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 48, color: Color(0xFF05CD99)),
                          const SizedBox(height: 8),
                          Text("All caught up", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor)),
                          Text("No pending requests to review.", style: TextStyle(fontSize: 12, color: subtitleColor)),
                        ],
                      ),
                    ),

                  if (pending.isNotEmpty) ...[
                    Text("Pending (${pending.length})", style: TextStyle(fontSize: 12, color: subtitleColor)),
                    const SizedBox(height: 10),
                    ...pending.map((req) {
                      return Card(
                        elevation: 0,
                        color: cardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF5B32E8),
                                    child: Text(getInitials(req.user), style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(req.user, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor)),
                                        Text("${req.userRole} · submitted ${req.submittedAt}", style: TextStyle(fontSize: 10, color: subtitleColor)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFF2E2657), borderRadius: BorderRadius.circular(12)),
                                    child: Text(req.type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text("Dates: ${req.from}${req.to != req.from ? ' → ' + req.to : ''}", style: TextStyle(fontSize: 11, color: subtitleColor)),
                              const SizedBox(height: 4),
                              Text('"${req.reason}"', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: titleColor)),
                              if (req.recommender != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle, size: 12, color: Color(0xFF05CD99)),
                                    const SizedBox(width: 4),
                                    Text("Screened by: ${req.recommender}", style: TextStyle(fontSize: 10, color: subtitleColor)),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.check, size: 16),
                                      label: Text(widget.role == Role.headOfDepartment ? "Approve" : "Recommend"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF5B32E8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      onPressed: () => _handleDecision(req.id, RequestStatus.approved),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.close, size: 16, color: Color(0xFFEE5D50)),
                                      label: const Text("Reject", style: TextStyle(color: Color(0xFFEE5D50))),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFEE5D50)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      onPressed: () => _handleDecision(req.id, RequestStatus.rejected),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ],

                // ── General Notifications Tab ──
                if (!isApprover || _tab == "notifications") ...[
                  if (isSuperAdmin)
                    _buildNotificationCard(
                      icon: Icons.inbox_rounded,
                      iconColor: const Color(0xFF8B5BF6),
                      iconBg: isDark ? const Color(0xFF2E2657) : const Color(0xFFF0EEFF),
                      title: "4 Pending Requests",
                      subtitle: "2 leave + 2 permission requests await your review. Go to Home → Pending Requests.",
                      time: "today",
                      isUnread: true,
                      cardColor: cardColor,
                      titleColor: titleColor,
                      subtitleColor: subtitleColor,
                    ),

                  if (widget.retrainRequired)
                    _buildNotificationCard(
                      icon: Icons.center_focus_strong,
                      iconColor: const Color(0xFFEE5D50),
                      iconBg: isDark ? const Color(0xFF3E1F28) : const Color(0xFFFFF0F0),
                      title: "Face Retraining Required",
                      subtitle: "SuperAdmin requested face data retrain.",
                      time: "now",
                      isUnread: true,
                      cardColor: cardColor,
                      titleColor: titleColor,
                      subtitleColor: subtitleColor,
                    ),

                  _buildNotificationCard(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: const Color(0xFF05CD99),
                    iconBg: isDark ? const Color(0xFF1E3A32) : const Color(0xFFE6F9F3),
                    title: "Leave Approved",
                    subtitle: "REQ-1038 has been approved by Lecturer Sok.",
                    time: "2h",
                    isUnread: true,
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildNotificationCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFFFB547),
                    iconBg: isDark ? const Color(0xFF3E321E) : const Color(0xFFFFF8E7),
                    title: "Absence Warning",
                    subtitle: "You have 3 absences this month.",
                    time: "1d",
                    isUnread: true,
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildNotificationCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF63B3ED),
                    iconBg: isDark ? const Color(0xFF1F2F44) : const Color(0xFFEBF5FF),
                    title: "Checked in",
                    subtitle: "Face recognized at 07:42 AM.",
                    time: "1d",
                    isUnread: false,
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildNotificationCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF63B3ED),
                    iconBg: isDark ? const Color(0xFF1F2F44) : const Color(0xFFEBF5FF),
                    title: "Telegram linked",
                    subtitle: "Notifications will also be sent to Telegram.",
                    time: "3d",
                    isUnread: false,
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
