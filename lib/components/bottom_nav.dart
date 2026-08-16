import 'package:flutter/material.dart';
import '../core/types.dart';

class BottomNavItem {
  final ScreenKey key;
  final String label;
  final IconData icon;

  BottomNavItem({required this.key, required this.label, required this.icon});
}

final List<BottomNavItem> allNavItems = [
  BottomNavItem(key: ScreenKey.home, label: "Home", icon: Icons.home_rounded),
  BottomNavItem(
      key: ScreenKey.history,
      label: "History",
      icon: Icons.description_rounded),
  BottomNavItem(
      key: ScreenKey.mark,
      label: "Scan",
      icon: Icons.center_focus_strong_rounded),
  BottomNavItem(
      key: ScreenKey.notifications,
      label: "Alerts",
      icon: Icons.notifications_rounded),
  BottomNavItem(
      key: ScreenKey.profile, label: "Profile", icon: Icons.person_rounded),
];

class BottomNav extends StatelessWidget {
  final ScreenKey active;
  final ValueChanged<ScreenKey> onChange;
  final Role role;

  const BottomNav({
    Key? key,
    required this.active,
    required this.onChange,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = allNavItems
        .where((i) => !(role == Role.superAdmin && i.key == ScreenKey.mark))
        .toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBgColor = isDark ? const Color(0xFF1F1B3E) : Colors.white;
    const activeColor = Color(0xFF8B5BF6);
    final inactiveColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      decoration: BoxDecoration(
        color: navBgColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFF382F6B) : const Color(0xFFE4E0FF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isActive = active == item.key;
            final isCenter =
                index == items.length ~/ 2 && items.length % 2 != 0;

            if (isCenter) {
              return Expanded(
                child: InkWell(
                  onTap: () => onChange(item.key),
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? activeColor
                              : activeColor.withOpacity(isDark ? 0.25 : 0.12),
                        ),
                        child: Icon(
                          item.icon,
                          size: 20,
                          color: isActive ? Colors.white : activeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Expanded(
              child: InkWell(
                onTap: () => onChange(item.key),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: isActive ? activeColor : inactiveColor,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.w500,
                          color: isActive ? activeColor : inactiveColor,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B5BF6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
