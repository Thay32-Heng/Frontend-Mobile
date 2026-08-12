import 'package:flutter/material.dart';
import '../types.dart';

Role roleFromEmail(String email) {
  final local = email.split('@')[0].toLowerCase();
  if (local.contains("admin")) return Role.superAdmin;
  if (local.contains("head") || local.contains("hod")) return Role.headOfDepartment;
  if (local.contains("lecturer") || local == "dara") return Role.lecturer;
  if (local.contains("monitor") || local == "manit") return Role.classMonitor;
  if (local.contains("assistant") || local == "dalin") return Role.assistant;
  if (local.contains("staff") || local == "panha") return Role.staff;
  return Role.student;
}

class LoginScreen extends StatefulWidget {
  final Function(Role role, String email) onLogin;

  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: "admin@school.edu");
  final _passwordController = TextEditingController(text: "••••••••");
  bool _showPass = false;
  bool _remember = false;

  void _handleSubmit() {
    final email = _emailController.text.trim();
    final role = roleFromEmail(email);
    widget.onLogin(role, email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFCDD8FA),
            Color(0xFFD8D0F5),
            Color(0xFFEAD0EE),
            Color(0xFFF5D5E4),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + Brand (Matching Screenshot with Face Scan Smile Icon)
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FaceScanSmileWidget(
                        size: 30,
                        color: Color(0xFF4318FF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SECURE ACCESS",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8F9BBA),
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Smart Attendance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2559),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              // Welcome Headers
              const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Enter your credentials to access your account",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8F9BBA),
                ),
              ),
              const SizedBox(height: 24),

              // Inputs Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4318FF).withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Email Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF1B2559)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.email_outlined, size: 20, color: Color(0xFF8F9BBA)),
                          hintText: "Email address",
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_showPass,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF1B2559)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF8F9BBA)),
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 20,
                              color: const Color(0xFF8F9BBA),
                            ),
                            onPressed: () => setState(() => _showPass = !_showPass),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Remember Me Row
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: _remember,
                            activeColor: const Color(0xFF4318FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (v) => setState(() => _remember = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Keep me logged in",
                          style: TextStyle(fontSize: 12, color: Color(0xFF8F9BBA)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4318FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF4318FF).withOpacity(0.4),
                        ),
                        onPressed: _handleSubmit,
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Roles Help Hint Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Color(0xFF8F9BBA)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Demo accounts: admin@school.edu, hod@school.edu, lecturer@school.edu, monitor@school.edu, student@school.edu",
                        style: TextStyle(fontSize: 10, color: Color(0xFF8F9BBA)),
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

class FaceScanSmileWidget extends StatelessWidget {
  final double size;
  final Color color;

  const FaceScanSmileWidget({
    Key? key,
    this.size = 30,
    this.color = const Color(0xFF4318FF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FaceScanSmilePainter(color: color),
    );
  }
}

class _FaceScanSmilePainter extends CustomPainter {
  final Color color;
  _FaceScanSmilePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.095
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final cornerLen = w * 0.26;
    final r = w * 0.12;

    // Top-left bracket ┌
    final pathTL = Path()
      ..moveTo(0, cornerLen)
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..lineTo(cornerLen, 0);
    canvas.drawPath(pathTL, paint);

    // Top-right bracket ┐
    final pathTR = Path()
      ..moveTo(w - cornerLen, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
      ..lineTo(w, cornerLen);
    canvas.drawPath(pathTR, paint);

    // Bottom-left bracket └
    final pathBL = Path()
      ..moveTo(0, h - cornerLen)
      ..lineTo(0, h - r)
      ..arcToPoint(Offset(r, h), radius: Radius.circular(r))
      ..lineTo(cornerLen, h);
    canvas.drawPath(pathBL, paint);

    // Bottom-right bracket ┘
    final pathBR = Path()
      ..moveTo(w - cornerLen, h)
      ..lineTo(w - r, h)
      ..arcToPoint(Offset(w, h - r), radius: Radius.circular(r))
      ..lineTo(w, h - cornerLen);
    canvas.drawPath(pathBR, paint);

    // Eyes (Two filled dots)
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final eyeR = w * 0.055;
    canvas.drawCircle(Offset(w * 0.36, h * 0.42), eyeR, fillPaint);
    canvas.drawCircle(Offset(w * 0.64, h * 0.42), eyeR, fillPaint);

    // Smile mouth ◡
    final smilePath = Path()
      ..moveTo(w * 0.34, h * 0.60)
      ..quadraticBezierTo(w * 0.50, h * 0.74, w * 0.66, h * 0.60);
    canvas.drawPath(smilePath, paint..strokeWidth = size.width * 0.085);
  }

  @override
  bool shouldRepaint(covariant _FaceScanSmilePainter oldDelegate) => oldDelegate.color != color;
}
