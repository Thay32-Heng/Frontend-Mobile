import 'package:flutter/material.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _auto = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final subtitleColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);
    final pillBgColor = isDark ? const Color(0xFF2E2657) : const Color(0xFFF7F5FF);
    final pillBorderColor = isDark ? const Color(0xFF3B326B) : const Color(0xFFE4E0FF);
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

    return Container(
      decoration: gradientDecoration,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Last Backup Status Card
          Card(
            elevation: 0,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  // Centered Database Icon Badge
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: initialBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.sd_storage_outlined, color: Color(0xFF8B5BF6), size: 24),
                  ),
                  const SizedBox(height: 12),

                  // Subtitles
                  Text(
                    "Last backup",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: titleColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "2026-05-29 06:00 AM • encrypted",
                    style: TextStyle(fontSize: 11, color: subtitleColor),
                  ),
                  const SizedBox(height: 12),

                  // Green Checkmark Shield Icon
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F9F3).withOpacity(isDark ? 0.2 : 1.0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: Color(0xFF05CD99), size: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Automatic Daily Backup Card
          Card(
            elevation: 0,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Automatic Daily Backup",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Runs at 6:00 AM, secure storage",
                    style: TextStyle(fontSize: 11, color: subtitleColor),
                  ),
                  const SizedBox(height: 12),
                  Switch(
                    value: _auto,
                    activeColor: const Color(0xFF8B5BF6),
                    onChanged: (v) => setState(() => _auto = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Actions Row Grid
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Backup started…")),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: pillBgColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: pillBorderColor),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, size: 18, color: Color(0xFF8B5BF6)),
                        SizedBox(width: 8),
                        Text("Backup Now", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Restore initiated")),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: pillBgColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: pillBorderColor),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_download_outlined, size: 18, color: Color(0xFF8B5BF6)),
                        SizedBox(width: 8),
                        Text("Restore", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF8B5BF6))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Backup History Card
          Card(
            elevation: 0,
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Backup History", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
                  const SizedBox(height: 10),
                  ...["2026-05-29 06:00", "2026-05-28 06:00", "2026-05-27 06:00"].map((d) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(d, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: titleColor)),
                          trailing: Text("12.4 MB", style: TextStyle(fontSize: 11, color: subtitleColor)),
                        ),
                        Divider(height: 1, color: isDark ? const Color(0xFF2F2853) : Colors.grey.shade100),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
