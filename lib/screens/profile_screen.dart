import 'package:flutter/material.dart';
import '../core/types.dart';

class ProfileScreen extends StatefulWidget {
  final Role role;
  final String name;
  final String email;
  final bool retrainRequired;
  final Function(ScreenKey key) onNavigate;
  final VoidCallback onLogout;

  const ProfileScreen({
    Key? key,
    required this.role,
    required this.name,
    required this.email,
    required this.retrainRequired,
    required this.onNavigate,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _displayName;
  late String _contactEmail;
  String _phone = "012 345 678";

  @override
  void initState() {
    super.initState();
    _displayName = widget.name;
    _contactEmail = widget.email;
  }

  void _showEditDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: isDark ? const Color(0xFF201B3E) : Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E1B4B),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B)),
                decoration: InputDecoration(
                  labelText: "Full name",
                  labelStyle:
                      TextStyle(color: isDark ? const Color(0xFFA0AEC0) : null),
                ),
                controller: TextEditingController(text: _displayName),
                onChanged: (v) => _displayName = v,
              ),
              const SizedBox(height: 8),
              TextField(
                style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B)),
                decoration: InputDecoration(
                  labelText: "Phone",
                  labelStyle:
                      TextStyle(color: isDark ? const Color(0xFFA0AEC0) : null),
                ),
                controller: TextEditingController(text: _phone),
                onChanged: (v) => _phone = v,
              ),
              const SizedBox(height: 8),
              TextField(
                style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E1B4B)),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle:
                      TextStyle(color: isDark ? const Color(0xFFA0AEC0) : null),
                ),
                controller: TextEditingController(text: _contactEmail),
                onChanged: (v) => _contactEmail = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B32E8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated")),
              );
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  void _showLogoutModal(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: isDark ? const Color(0xFF201B3E) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Log out?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: isDark
                          ? const Color(0xFFA0AEC0)
                          : const Color(0xFF8F9BBA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "You will be returned to the sign-in screen and your session will be cleared.",
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFFA0AEC0)
                      : const Color(0xFF8F9BBA),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF3B326B)
                            : const Color(0xFFE4E0FF),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5103B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onLogout();
                    },
                    child: const Text(
                      "Log out",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = getInitials(_displayName);
    final isSuperAdmin = widget.role == Role.superAdmin;
    final retrainLocked = !widget.retrainRequired;

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

    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final subtitleColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);
    final pillBgColor =
        isDark ? const Color(0xFF2E2657) : const Color(0xFFF0EEFF);
    final dividerColor =
        isDark ? const Color(0xFF2F2853) : Colors.grey.shade100;

    return Container(
      decoration: gradientDecoration,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: const Color(0xFF5B32E8),
                    child: Text(
                      initials,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _displayName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _contactEmail,
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: pillBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      roleLabels[widget.role]!,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5BF6)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () => _showEditDialog(isDark),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.edit_outlined,
                          color: subtitleColor, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Column(
              children: [
                if (!isSuperAdmin) ...[
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Icon(
                      Icons.center_focus_strong,
                      color:
                          retrainLocked ? Colors.grey.shade600 : subtitleColor,
                    ),
                    title: Text(
                      "Retrain Face Data",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            retrainLocked ? Colors.grey.shade600 : titleColor,
                      ),
                    ),
                    trailing: retrainLocked
                        ? const Icon(Icons.lock_outline,
                            size: 16, color: Colors.grey)
                        : Icon(Icons.chevron_right_rounded,
                            size: 18, color: subtitleColor),
                    onTap: () {
                      if (retrainLocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Retraining is locked until SuperAdmin authorizes it.")),
                        );
                      } else {
                        widget.onNavigate(ScreenKey.faceCapture);
                      }
                    },
                  ),
                  Divider(height: 1, color: dividerColor),
                ],
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Icon(Icons.settings_outlined, color: subtitleColor),
                  title: Text("Settings",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: titleColor)),
                  trailing: Icon(Icons.chevron_right_rounded,
                      size: 18, color: subtitleColor),
                  onTap: () => widget.onNavigate(ScreenKey.settings),
                ),
                Divider(height: 1, color: dividerColor),
                if (isSuperAdmin) ...[
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading:
                        Icon(Icons.sd_storage_outlined, color: subtitleColor),
                    title: Text("Backup & Restore",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: titleColor)),
                    trailing: Icon(Icons.chevron_right_rounded,
                        size: 18, color: subtitleColor),
                    onTap: () => widget.onNavigate(ScreenKey.backup),
                  ),
                  Divider(height: 1, color: dividerColor),
                ],
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: const Icon(Icons.logout_rounded,
                      color: Color(0xFFEE5D50)),
                  title: const Text("Logout",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEE5D50))),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      size: 18, color: Color(0xFFEE5D50)),
                  onTap: () => _showLogoutModal(isDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!isSuperAdmin && retrainLocked)
            Text(
              "Face retraining is locked until SuperAdmin sends a retrain notification.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: subtitleColor),
            ),
        ],
      ),
    );
  }
}
