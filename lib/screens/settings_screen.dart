import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool dark;
  final ValueChanged<bool> onToggleDark;
  final bool retrainRequired;
  final VoidCallback onRetrainComplete;
  final bool isSuperAdmin;
  final VoidCallback? onRequestRetrainAll;

  const SettingsScreen({
    Key? key,
    required this.dark,
    required this.onToggleDark,
    required this.retrainRequired,
    required this.onRetrainComplete,
    required this.isSuperAdmin,
    this.onRequestRetrainAll,
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
    final isDark =
        widget.dark || Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final inputBgColor =
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Appearance",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5BF6)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            size: 20,
                            color: titleColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Dark Mode",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: titleColor),
                          ),
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
          if (!widget.isSuperAdmin)
            _buildFaceDataCard(cardColor, titleColor, isDark)
          else
            _buildRequestRetrainAllCard(cardColor, titleColor, isDark),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5BF6)),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingSwitchRow("Push notifications", _push,
                      titleColor, (v) => setState(() => _push = v)),
                  const SizedBox(height: 12),
                  _buildSettingSwitchRow("Telegram alerts", _telegram,
                      titleColor, (v) => setState(() => _telegram = v)),
                  const SizedBox(height: 12),
                  _buildSettingSwitchRow("Absence warnings", _absence,
                      titleColor, (v) => setState(() => _absence = v)),
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Change Password",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 16),
                  Text("Current",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 6),
                  _buildPillPasswordField(
                      _currentPasswordCtrl, inputBgColor, titleColor),
                  const SizedBox(height: 12),
                  Text("New",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 6),
                  _buildPillPasswordField(
                      _newPasswordCtrl, inputBgColor, titleColor),
                  const SizedBox(height: 12),
                  Text("Confirm",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 6),
                  _buildPillPasswordField(
                      _confirmPasswordCtrl, inputBgColor, titleColor),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B32E8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Password updated successfully")),
                        );
                      },
                      child: const Text("Update Password",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
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

  Widget _buildFaceDataCard(Color cardColor, Color titleColor, bool isDark) {
    final locked = !widget.retrainRequired;

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Face Data",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5BF6)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.center_focus_strong,
                  size: 20,
                  color: locked ? Colors.grey.shade600 : titleColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    locked
                        ? "Retraining is locked until SuperAdmin authorizes it."
                        : "SuperAdmin has requested a face data retrain.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: locked ? Colors.grey.shade600 : titleColor,
                    ),
                  ),
                ),
                if (locked)
                  const Icon(Icons.lock_outline, size: 16, color: Colors.grey)
                else
                  TextButton(
                    onPressed: () {
                      widget.onRetrainComplete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Face data retrained successfully")),
                      );
                    },
                    child: const Text(
                      "Retrain Now",
                      style: TextStyle(
                          color: Color(0xFF8B5BF6),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestRetrainAllCard(
      Color cardColor, Color titleColor, bool isDark) {
    final subtitleColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Face Data",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5BF6)),
            ),
            const SizedBox(height: 4),
            Text(
              "SuperAdmin is outside the face dataset. You can still request every stakeholder to retrain.",
              style: TextStyle(fontSize: 11, color: subtitleColor),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.center_focus_strong,
                    size: 18, color: Color(0xFF8B5BF6)),
                label: Text(
                  widget.retrainRequired
                      ? "Retrain Already Requested"
                      : "Request Face Retrain (All Users)",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5BF6)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8B5BF6)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: widget.retrainRequired
                    ? null
                    : () {
                        widget.onRequestRetrainAll?.call();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Retrain request sent to all stakeholders")),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitchRow(String label, bool value, Color titleColor,
      ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: titleColor)),
        Switch(
          value: value,
          activeColor: const Color(0xFF8B5BF6),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPillPasswordField(
      TextEditingController controller, Color inputBgColor, Color titleColor) {
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
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
