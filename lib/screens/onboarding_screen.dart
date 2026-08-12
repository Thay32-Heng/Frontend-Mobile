import 'package:flutter/material.dart';
import '../types.dart';

class OnboardingScreen extends StatefulWidget {
  final Role role;
  final String name;
  final String email;
  final VoidCallback onComplete;

  const OnboardingScreen({
    Key? key,
    required this.role,
    required this.name,
    required this.email,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final _pwController = TextEditingController();
  final _pw2Controller = TextEditingController();
  bool _showPass = false;
  bool _capturing = false;
  int _captured = 0;

  void _startCapture() {
    setState(() {
      _capturing = true;
      _captured = 0;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _captured = 1);
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _captured = 2);
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            setState(() {
              _captured = 3;
              _capturing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Face enrolled successfully")),
            );
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pwValid = _pwController.text.length >= 8 && _pwController.text == _pw2Controller.text;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x1A4318FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Bar Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(3, (index) {
                        final isActive = index == _step;
                        final isDone = index < _step;

                        return Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isDone || isActive ? const Color(0xFF4318FF) : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: isDone
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : Text(
                                          "${index + 1}",
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                ),
                              ),
                              if (index < 2)
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: isDone ? const Color(0xFF4318FF) : Colors.grey.shade300,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Step ${_step + 1} of 3 · ${["Welcome", "Set Password", "Capture Face"][_step]}",
                      style: const TextStyle(fontSize: 11, color: Color(0xFF8F9BBA)),
                    ),
                  ],
                ),
              ),

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      if (_step == 0) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4318FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.celebration, size: 32, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Welcome, ${widget.name.split(' ')[0]}!",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your ${roleLabels[widget.role]} account is ready. Let's finish setup so you can start checking in with your face.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF8F9BBA)),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Signed in as", style: TextStyle(fontSize: 11, color: Color(0xFF8F9BBA))),
                                Text(widget.email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: const Padding(
                            padding: EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("You'll do two quick things:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.vpn_key_outlined, size: 16, color: Color(0xFF4318FF)),
                                    SizedBox(width: 8),
                                    Text("Change your temporary password", style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.center_focus_strong, size: 16, color: Color(0xFF4318FF)),
                                    SizedBox(width: 8),
                                    Text("Capture your face from 3 angles", style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      if (_step == 1) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4318FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.vpn_key, size: 28, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Set a new password",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Your SuperAdmin gave you a temporary password. Choose a new one only you know.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Color(0xFF8F9BBA)),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("New password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _pwController,
                                  obscureText: !_showPass,
                                  decoration: InputDecoration(
                                    hintText: "At least 8 characters",
                                    suffixIcon: IconButton(
                                      icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () => setState(() => _showPass = !_showPass),
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 14),
                                const Text("Confirm password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _pw2Controller,
                                  obscureText: !_showPass,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Icon(Icons.shield_outlined, size: 14, color: Color(0xFF8F9BBA)),
                                    SizedBox(width: 4),
                                    Text("Min 8 chars. Use letters, numbers & symbols.", style: TextStyle(fontSize: 10, color: Color(0xFF8F9BBA))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      if (_step == 2) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4318FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.center_focus_strong, size: 28, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Capture your face",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Face the camera in good lighting. We'll take 3 quick samples to train your model.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Color(0xFF8F9BBA)),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade900,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(Icons.camera_alt, size: 40, color: Colors.white38),
                                      if (_capturing)
                                        Container(
                                          color: Colors.black54,
                                          alignment: Alignment.center,
                                          child: Text("Capturing… $_captured/3", style: const TextStyle(color: Colors.white, fontSize: 13)),
                                        ),
                                      if (!_capturing && _captured == 3)
                                        Container(
                                          color: const Color(0xD905CD99),
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.check, size: 48, color: Colors.white),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _capturing ? null : _startCapture,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4318FF),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text(_capturing ? "Capturing…" : _captured == 3 ? "Recapture" : "Start Capture"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Footer Action Controls
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    if (_step > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _step--),
                          child: const Text("Back"),
                        ),
                      ),
                    if (_step > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4318FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: (_step == 1 && !pwValid) || (_step == 2 && _captured < 3)
                            ? null
                            : () {
                                if (_step < 2) {
                                  setState(() => _step++);
                                } else {
                                  widget.onComplete();
                                }
                              },
                        child: Text(_step < 2 ? "Continue" : "Finish"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
