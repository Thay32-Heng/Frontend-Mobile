import 'package:flutter/material.dart';
import '../types.dart';
import '../mock_data.dart';

class UserManagementScreen extends StatefulWidget {
  final bool isSuperAdmin;
  final bool retrainRequested;
  final VoidCallback onRequestRetrain;

  const UserManagementScreen({
    Key? key,
    required this.isSuperAdmin,
    required this.retrainRequested,
    required this.onRequestRetrain,
  }) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<ManagedUser> _users = List.from(mockUsersData);
  String? _selectedRole;
  String _q = "";

  void _showCreateDialog(bool isDark) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: isDark ? const Color(0xFF201B3E) : Colors.white,
        title: Text("Create User", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E1B4B))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E1B4B)), decoration: const InputDecoration(labelText: "Full name")),
            const SizedBox(height: 8),
            TextField(controller: emailCtrl, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E1B4B)), decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B32E8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _users.add(ManagedUser(
                    id: "U-00${_users.length + 1}",
                    name: nameCtrl.text,
                    role: _selectedRole ?? "Student",
                    email: emailCtrl.text,
                    active: true,
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User created")));
              }
            },
            child: const Text("Create"),
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
    final initialBgColor = isDark ? const Color(0xFF2E2657) : const Color(0xFFF0EEFF);

    final gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF14112A), const Color(0xFF191535), const Color(0xFF211A42)]
            : [const Color(0xFFE4E0FF), const Color(0xFFEFE8FF), const Color(0xFFFAE8F4)],
      ),
    );

    // Level 2: Users List for Selected Role
    if (_selectedRole != null) {
      final list = _users
          .where((u) => u.role == _selectedRole)
          .where((u) => u.name.toLowerCase().contains(_q.toLowerCase()) || u.email.toLowerCase().contains(_q.toLowerCase()))
          .toList();

      return Container(
        decoration: gradientDecoration,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextButton.icon(
              icon: const Icon(Icons.chevron_left, size: 18),
              label: const Text("Back to stakeholders", style: TextStyle(color: Color(0xFF8B5BF6))),
              onPressed: () => setState(() { _selectedRole = null; _q = ""; }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$_selectedRole (${list.length})", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add_rounded, size: 16),
                  label: const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B32E8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _showCreateDialog(isDark),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              style: TextStyle(color: titleColor),
              decoration: InputDecoration(
                hintText: "Search $_selectedRole…",
                hintStyle: TextStyle(color: subtitleColor),
                prefixIcon: Icon(Icons.search_rounded, size: 20, color: subtitleColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (v) => setState(() => _q = v),
            ),
            const SizedBox(height: 14),
            ...list.map((u) {
              return Card(
                elevation: 0,
                color: cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF5B32E8),
                        child: Text(getInitials(u.name), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor)),
                            Text(u.email, style: TextStyle(fontSize: 11, color: subtitleColor)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: u.active ? const Color(0xFFE6F9F3).withOpacity(isDark ? 0.2 : 1.0) : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                u.active ? "Active" : "Disabled",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: u.active ? const Color(0xFF05CD99) : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Switch(
                            value: u.active,
                            activeColor: const Color(0xFF8B5BF6),
                            onChanged: (v) {
                              setState(() => u.active = v);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(v ? "Account activated" : "Account deactivated")),
                              );
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.vpn_key_outlined, size: 16, color: subtitleColor),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password reset sent")));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEE5D50)),
                                onPressed: () {
                                  setState(() => _users.removeWhere((x) => x.id == u.id));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User deleted")));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    }

    // Level 1: Stakeholder Roles List
    return Container(
      decoration: gradientDecoration,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Face Retraining Card
          if (widget.isSuperAdmin)
            Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  children: [
                    // Centered Icon Badge
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: initialBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.center_focus_strong_rounded, color: Color(0xFF8B5BF6), size: 24),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text("Face Retraining", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor)),
                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      widget.retrainRequested ? "Notification sent — users can now retrain." : "Notify all stakeholders to retrain their face data.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: subtitleColor),
                    ),
                    const SizedBox(height: 16),

                    // Notify All Pill Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.retrainRequested ? Colors.grey : const Color(0xFF5B32E8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: widget.retrainRequested
                          ? null
                          : () {
                              widget.onRequestRetrain();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Retrain notification sent to all stakeholders")),
                              );
                            },
                      child: Text(
                        widget.retrainRequested ? "Sent" : "Notify All",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Subheader
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text("Choose a stakeholder to manage", style: TextStyle(fontSize: 12, color: subtitleColor)),
          ),

          // 2. Stakeholder Cards
          ...["Head of Department", "Lecturer", "Class Monitor", "Assistant", "Student", "Staff"].map((r) {
            final roleUsers = _users.where((u) => u.role == r).toList();
            final activeCount = roleUsers.where((u) => u.active).length;

            return Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => setState(() => _selectedRole = r),
                borderRadius: BorderRadius.circular(28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      // Centered Initial Badge
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
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(r, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor)),
                      const SizedBox(height: 2),

                      // Subtitle
                      Text(
                        "${roleUsers.length} user${roleUsers.length == 1 ? '' : 's'} · $activeCount active",
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                      ),
                      const SizedBox(height: 14),

                      // Centered Chevron Indicator
                      Icon(Icons.chevron_right_rounded, size: 20, color: subtitleColor),
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
}
