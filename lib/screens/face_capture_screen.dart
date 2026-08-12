import 'package:flutter/material.dart';

class FaceCaptureScreen extends StatefulWidget {
  final VoidCallback onDone;

  const FaceCaptureScreen({Key? key, required this.onDone}) : super(key: key);

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  final List<String> angles = ["Front", "Left", "Right", "Up", "Down"];
  final Set<String> captured = {};

  void _capture(String angle) {
    if (captured.contains(angle)) return;
    setState(() {
      captured.add(angle);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$angle captured • quality 92%")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDone = captured.length == angles.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.grey.shade100,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  "Capture your face from 5 angles. Hold still in good lighting.",
                  style: TextStyle(fontSize: 13, color: Color(0xFF1B2559)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Camera Viewfinder Box
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 64, color: Colors.white38),
                    Positioned(
                      bottom: 12,
                      child: Text(
                        "Quality: ${captured.isEmpty ? '—' : '92%'} • ${captured.length}/${angles.length}",
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5 Angles Grid
            Row(
              children: angles.map((a) {
                final isDone = captured.contains(a);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: InkWell(
                      onTap: () => _capture(a),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isDone ? const Color(0x1A05CD99) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDone ? const Color(0xFF05CD99) : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              isDone ? Icons.check_circle : Icons.camera_alt,
                              size: 16,
                              color: isDone ? const Color(0xFF05CD99) : Colors.grey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              a,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                                color: isDone ? const Color(0xFF05CD99) : const Color(0xFF1B2559),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4318FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: allDone
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Face dataset saved")),
                        );
                        widget.onDone();
                      }
                    : null,
                child: Text(
                  allDone ? "Save Face Dataset" : "Capture ${angles.length - captured.length} more",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
