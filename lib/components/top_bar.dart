import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onBell;
  final int unread;
  final Widget? right;

  const TopBar({
    Key? key,
    required this.title,
    this.onBack,
    this.onBell,
    this.unread = 0,
    this.right,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color:
            isDark ? const Color(0xFF1E1B3A) : Colors.white.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.08),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56.0,
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  onPressed: onBack,
                  color: isDark ? Colors.white : const Color(0xFF1B2559),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                )
              else
                const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1B2559),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (right != null) right!,
              if (onBell != null)
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 22),
                      onPressed: onBell,
                      color: isDark ? Colors.white : const Color(0xFF1B2559),
                    ),
                    if (unread > 0)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
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
}
