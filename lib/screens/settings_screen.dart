import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool dark;
  final ValueChanged<bool> onToggleDark;
  final bool retrainRequired;
  final VoidCallback onRetrainComplete;
  final bool isSuperAdmin;

  const SettingsScreen({
    Key? key,
    required this.dark,
    required this.onToggleDark,
    required this.retrainRequired,
    required this.onRetrainComplete,
    required this.isSuperAdmin,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _push = true;
  bool _telegram = true;
  bool _absence = true;
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = widget.dark || Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final inputBgColor = isDark ? const Color(0xFF2E2657) : const Color(0xFFF0EEFF);

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
          // 1. Appearance Card
          Card(
            elevation: 0,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Appearance", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, size: 20, color: titleColor),
                          const SizedBox(width: 10),
                          Text("Dark Mode", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleColor)),
                        ],
                      ),
                      Switch(
                        value: widget.dark,
                        activeColor: const Color(0xFF8B5BF6),
                        onChanged: widget.onToggleDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Notifications Card
          Card(
            elevation: 0,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Notifications", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                  const SizedBox(height: 10),

                  _buildSettingSwitchRow("Push notifications", _push, titleColor, (v) => setState(() => _push = v)),
                  const SizedBox(height: 12),
                  _buildSettingSwitchRow("Telegram alerts", _telegram, titleColor, (v) => setState(() => _telegram = v)),
                  const SizedBox(height: 12),
                  _buildSettingSwitchRow("Absence warnings", _absence, titleColor, (v) => setState(() => _absence = v)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Change Password Card
          Card(
            elevation: 0,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Change Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor)),
                  const SizedBox(height: 16),

                  Text("Current", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: titleColor)),
                  const SizedBox(height: 6),
                  _buildPillPasswordField(_currentPasswordCtrl, inputBgColor, titleColor),
                  const SizedBox(height: 12),

                  Text("New", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: titleColor)),
                  const SizedBox(height: 6),
                  _buildPillPasswordField(_newPasswordCtrl, inputBgColor, titleColor),
                  const SizedBox(height: 12),

                  Text("Confirm", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: titleColor)),
                  const SizedBox(height: 6),
                  _buildPillPasswordField(_confirmPasswordCtrl, inputBgColor, titleColor),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B32E8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password updated successfully")),
                        );
                      },
                      child: const Text("Update Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitchRow(String label, bool value, Color titleColor, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: titleColor)),
        Switch(
          value: value,
          activeColor: const Color(0xFF8B5BF6),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPillPasswordField(TextEditingController controller, Color inputBgColor, Color titleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: TextStyle(fontSize: 14, color: titleColor),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
