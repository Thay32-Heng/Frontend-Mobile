import 'package:flutter/material.dart';

class StrokePoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  StrokePoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });
}

class DrawCanvasModal extends StatefulWidget {
  final VoidCallback onClose;

  const DrawCanvasModal({Key? key, required this.onClose}) : super(key: key);

  @override
  State<DrawCanvasModal> createState() => _DrawCanvasModalState();
}

class _DrawCanvasModalState extends State<DrawCanvasModal> {
  final List<List<StrokePoint>> _paths = [];
  final List<List<StrokePoint>> _undoHistory = [];
  List<StrokePoint> _currentPath = [];

  String _tool = "pen"; // "pen" | "eraser"
  Color _color = const Color(0xFF6366F1); // Indigo
  double _size = 4.0;
  bool _collapsed = false;

  final List<Map<String, dynamic>> _colors = [
    {"label": "Ink", "value": const Color(0xFF1E1B4B)},
    {"label": "Coral", "value": const Color(0xFFEF4444)},
    {"label": "Indigo", "value": const Color(0xFF6366F1)},
    {"label": "Emerald", "value": const Color(0xFF10B981)},
    {"label": "Amber", "value": const Color(0xFFF59E0B)},
    {"label": "White", "value": Colors.white},
  ];

  final List<double> _sizes = [2.0, 4.0, 8.0, 16.0];

  void _undo() {
    if (_paths.isNotEmpty) {
      setState(() {
        _undoHistory.add(_paths.removeLast());
      });
    }
  }

  void _clear() {
    setState(() {
      _paths.clear();
      _undoHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Touch Canvas area
        Positioned.fill(
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _currentPath = [
                  StrokePoint(
                    offset: details.localPosition,
                    color: _tool == "eraser" ? const Color(0xFF14112A) : _color,
                    strokeWidth: _tool == "eraser" ? _size * 4 : _size,
                    isEraser: _tool == "eraser",
                  )
                ];
                _paths.add(_currentPath);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _currentPath.add(
                  StrokePoint(
                    offset: details.localPosition,
                    color: _tool == "eraser" ? const Color(0xFF14112A) : _color,
                    strokeWidth: _tool == "eraser" ? _size * 4 : _size,
                    isEraser: _tool == "eraser",
                  ),
                );
              });
            },
            child: CustomPaint(
              painter: CanvasPainter(paths: _paths),
              size: Size.infinite,
            ),
          ),
        ),

        // Banner at Top
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xD96366F1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x4D6366F1), blurRadius: 16, offset: Offset(0, 4)),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 14, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    "DRAW MODE",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Floating Toolbar on Right Side
        Positioned(
          right: 16,
          top: MediaQuery.of(context).size.height * 0.25,
          child: Container(
            width: _collapsed ? 48 : 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xEB0F0D28),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle Collapse / Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _collapsed = !_collapsed),
                      child: Icon(_collapsed ? Icons.chevron_left : Icons.chevron_right, size: 18, color: Colors.white54),
                    ),
                    if (!_collapsed) ...[
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: widget.onClose,
                        child: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                      ),
                    ],
                  ],
                ),
                const Divider(color: Colors.white12, height: 16),

                if (!_collapsed) ...[
                  // Pen / Eraser Tool
                  IconButton(
                    icon: Icon(Icons.create, size: 18, color: _tool == "pen" ? const Color(0xFF6366F1) : Colors.white54),
                    onPressed: () => setState(() => _tool = "pen"),
                  ),
                  IconButton(
                    icon: Icon(Icons.cleaning_services_rounded, size: 18, color: _tool == "eraser" ? const Color(0xFF6366F1) : Colors.white54),
                    onPressed: () => setState(() => _tool = "eraser"),
                  ),
                  const Divider(color: Colors.white12, height: 16),

                  // Stroke Sizes
                  ..._sizes.map((s) => InkWell(
                    onTap: () => setState(() => _size = s),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _size == s ? const Color(0x336366F1) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: s.clamp(4.0, 16.0),
                        height: s.clamp(4.0, 16.0),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                  )).toList(),
                  const Divider(color: Colors.white12, height: 16),

                  // Colors
                  ..._colors.map((c) => InkWell(
                    onTap: () => setState(() {
                      _color = c["value"] as Color;
                      if (_tool == "eraser") _tool = "pen";
                    }),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: c["value"] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == c["value"] ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  )).toList(),
                  const Divider(color: Colors.white12, height: 16),

                  // Undo & Clear
                  IconButton(
                    icon: const Icon(Icons.undo, size: 18, color: Colors.white54),
                    onPressed: _paths.isNotEmpty ? _undo : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                    onPressed: _clear,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<List<StrokePoint>> paths;

  CanvasPainter({required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    for (final path in paths) {
      if (path.isEmpty) continue;

      final paint = Paint()
        ..color = path.first.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = path.first.strokeWidth
        ..style = PaintingStyle.stroke;

      if (path.length == 1) {
        canvas.drawCircle(path.first.offset, path.first.strokeWidth / 2, paint..style = PaintingStyle.fill);
      } else {
        final p = Path()..moveTo(path.first.offset.dx, path.first.offset.dy);
        for (int i = 1; i < path.length; i++) {
          p.lineTo(path[i].offset.dx, path[i].offset.dy);
        }
        canvas.drawPath(p, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) => true;
}
