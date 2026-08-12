import 'dart:async';
import 'package:flutter/material.dart';

class AttendanceMarkScreen extends StatefulWidget {
  final VoidCallback onDone;

  const AttendanceMarkScreen({Key? key, required this.onDone}) : super(key: key);

  @override
  State<AttendanceMarkScreen> createState() => _AttendanceMarkScreenState();
}

class _AttendanceMarkScreenState extends State<AttendanceMarkScreen> {
  String _mode = "in"; // "in" | "out"
  String _phase = "idle"; // "idle" | "scanning" | "success"
  int _progress = 0;
  Timer? _timer;

  void _startScan(String m) {
    setState(() {
      _mode = m;
      _progress = 0;
      _phase = "scanning";
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      setState(() {
        if (_progress >= 100) {
          _timer?.cancel();
          _phase = "success";
          final now = TimeOfDay.now().format(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _mode == "in" ? "Check-in successful at $now" : "Check-out recorded at $now",
              ),
              backgroundColor: const Color(0xFF05CD99),
            ),
          );
        } else {
          _progress += 5;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isModeIn = _mode == "in";
    final themeColor = isModeIn ? const Color(0xFF05CD99) : const Color(0xFF38BDF8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Mode Switch Tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _phase == "scanning" ? null : () => setState(() => _mode = "in"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isModeIn ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isModeIn ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, size: 16, color: isModeIn ? const Color(0xFF1B2559) : Colors.grey),
                            const SizedBox(width: 6),
                            Text("Check-In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isModeIn ? const Color(0xFF1B2559) : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: _phase == "scanning" ? null : () => setState(() => _mode = "out"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !isModeIn ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: !isModeIn ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 16, color: !isModeIn ? const Color(0xFF1B2559) : Colors.grey),
                            const SizedBox(width: 6),
                            Text("Check-Out", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: !isModeIn ? const Color(0xFF1B2559) : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Camera Viewfinder Simulation
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Face Guide Oval
                  Container(
                    width: 220,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(100), bottom: Radius.circular(100)),
                      border: Border.all(color: themeColor, width: 2),
                    ),
                    child: Center(
                      child: _phase == "success"
                          ? Icon(Icons.check_circle_outline, size: 80, color: themeColor)
                          : Icon(Icons.center_focus_strong, size: 80, color: themeColor.withOpacity(0.6)),
                    ),
                  ),

                  // Animated Scanning Laser Line
                  if (_phase == "scanning")
                    Positioned(
                      top: 40 + (240 * (_progress / 100)),
                      left: 60,
                      right: 60,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: themeColor,
                          boxShadow: [
                            BoxShadow(color: themeColor, blurRadius: 12, spreadRadius: 2),
                          ],
                        ),
                      ),
                    ),

                  // Status Indicator Text below
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      _phase == "idle"
                          ? "Tap a button below to ${_mode == 'in' ? 'check in' : 'check out'}"
                          : _phase == "scanning"
                              ? "Recognizing… $_progress%"
                              : (_mode == "in" ? "Welcome — checked in!" : "See you tomorrow — checked out!"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_phase == "success")
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2559),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: widget.onDone,
                      child: const Text("Done"),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.login, size: 18),
                            label: const Text("Check-In"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF05CD99),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _phase == "scanning" ? null : () => _startScan("in"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.logout, size: 18, color: Color(0xFF0284C7)),
                            label: const Text("Check-Out", style: TextStyle(color: Color(0xFF0284C7))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0284C7)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _phase == "scanning" ? null : () => _startScan("out"),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                const Text(
                  "Liveness check active • timestamp recorded automatically",
                  style: TextStyle(fontSize: 11, color: Color(0xFF8F9BBA)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
