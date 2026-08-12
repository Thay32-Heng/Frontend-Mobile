import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;
  final bool dark;

  const PhoneFrame({
    Key? key,
    required this.child,
    this.dark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [const Color(0xFF0F0D28), const Color(0xFF14112A), const Color(0xFF1E1B3A)]
              : [const Color(0xFFD9DCFF), const Color(0xFFE8D5FF), const Color(0xFFFFD6EA)],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440, maxHeight: 920),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF14112A) : Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(
              color: dark ? Colors.white.withOpacity(0.1) : Colors.white,
              width: 4,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Phone Notch / Speaker Bar
              Container(
                height: 28,
                color: dark ? const Color(0xFF14112A) : Colors.white,
                child: Center(
                  child: Container(
                    width: 90,
                    height: 4,
                    decoration: BoxDecoration(
                      color: dark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
