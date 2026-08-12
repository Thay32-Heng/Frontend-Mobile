import 'package:flutter/material.dart';
import '../types.dart';
import '../mock_data.dart';

class SessionItem {
  final String id;
  final String subject;
  final String time;
  final String room;

  SessionItem(this.id, this.subject, this.time, this.room);
}

final List<SessionItem> sessionsList = [
  SessionItem("S1", "Database Systems", "07:30–09:00", "B201"),
  SessionItem("S2", "Web Programming", "10:00–11:30", "B105"),
  SessionItem("S3", "Data Structures", "13:00–14:30", "B301"),
];

class RosterStudent {
  final String id;
  final String name;
  final String role;
  String status; // "Present" | "Late" | "Absent" | "Leave"
  String checkIn;
  String note;

  RosterStudent({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    required this.checkIn,
    this.note = "",
  });
}

class ClassAttendanceScreen extends StatefulWidget {
  final Role role;

  const ClassAttendanceScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen> {
  SessionItem _selectedSession = sessionsList[0];
  bool _sessionOpen = false;
  bool _submitted = false;
  late List<RosterStudent> _roster;

  @override
  void initState() {
    super.initState();
    final students = usersByRoleData["Student"] ?? [];
    final statuses = ["Present", "Present", "Late", "Absent"];
    final checkIns = ["07:42", "07:38", "08:18", "—"];

    _roster = students.asMap().entries.map((entry) {
      final i = entry.key;
      final u = entry.value;
      return RosterStudent(
        id: u.id,
        name: u.user,
        role: u.role,
        status: statuses[i % statuses.length],
        checkIn: checkIns[i % checkIns.length],
      );
    }).toList();
  }

  void _cycleStatus(RosterStudent s) {
    if (_submitted) return;
    const statuses = ["Present", "Late", "Absent", "Leave"];
    final nextIdx = (statuses.indexOf(s.status) + 1) % statuses.length;
    setState(() {
      s.status = statuses[nextIdx];
    });
  }

  void _editNote(RosterStudent s) {
    final noteCtrl = TextEditingController(text: s.note);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Note for ${s.name}"),
        content: TextField(
          controller: noteCtrl,
          decoration: const InputDecoration(hintText: "Add note…", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() => s.note = noteCtrl.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Note saved")));
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final present = _roster.where((s) => s.status == "Present").length;
    final late = _roster.where((s) => s.status == "Late").length;
    final absent = _roster.where((s) => s.status == "Absent").length;
    final leave = _roster.where((s) => s.status == "Leave").length;
    final rate = _roster.isEmpty ? 0 : (((present + late) / _roster.length) * 100).round();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDDE4FF), Color(0xFFEAD5FF), Color(0xFFFFD6EA)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Session Selector Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              onTap: () => setState(() => _sessionOpen = !_sessionOpen),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: const Color(0x1A4318FF), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.calendar_today, color: Color(0xFF4318FF), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedSession.subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                          Text("${_selectedSession.time} · ${_selectedSession.room}", style: const TextStyle(fontSize: 11, color: Color(0xFF8F9BBA))),
                        ],
                      ),
                    ),
                    Icon(_sessionOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF8F9BBA)),
                  ],
                ),
              ),
            ),
          ),
          if (_sessionOpen) ...[
            const SizedBox(height: 6),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: sessionsList.map((s) {
                  final isSelected = s.id == _selectedSession.id;
                  return ListTile(
                    title: Text(s.subject, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: const Color(0xFF1B2559))),
                    subtitle: Text("${s.time} · ${s.room}", style: const TextStyle(fontSize: 11, color: Color(0xFF8F9BBA))),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF4318FF), size: 18) : null,
                    onTap: () => setState(() {
                      _selectedSession = s;
                      _sessionOpen = false;
                      _submitted = false;
                    }),
                  );
                }).toList(),
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Roster Summary Progress Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.people, size: 18, color: Color(0xFF8F9BBA)),
                  const SizedBox(width: 6),
                  Text("${_roster.length}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                  const SizedBox(width: 4),
                  const Text("students", style: TextStyle(fontSize: 12, color: Color(0xFF8F9BBA))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: rate / 100, backgroundColor: Colors.grey.shade200, color: const Color(0xFF05CD99), minHeight: 6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("$rate%", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF05CD99))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 4 Status Counts Row
          Row(
            children: [
              _buildCountCard("Present", present, const Color(0xFF05CD99), Icons.check_circle_outline),
              _buildCountCard("Late", late, const Color(0xFFFFB547), Icons.access_time),
              _buildCountCard("Absent", absent, const Color(0xFFEE5D50), Icons.cancel_outlined),
              _buildCountCard("Leave", leave, const Color(0xFF63B3ED), Icons.calendar_today),
            ],
          ),
          const SizedBox(height: 14),

          if (_submitted)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: const Color(0x1A05CD99), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0x4D05CD99))),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF05CD99), size: 18),
                  const SizedBox(width: 8),
                  Text("Attendance submitted · ${_selectedSession.subject}", style: const TextStyle(color: Color(0xFF05CD99), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),

          // Student Roster List
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Student Roster (Tap status to cycle)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                  const SizedBox(height: 10),
                  ..._roster.map((s) {
                    Color badgeBg = const Color(0x1A05CD99);
                    Color badgeColor = const Color(0xFF05CD99);
                    if (s.status == "Late") { badgeBg = const Color(0x1AFFB547); badgeColor = const Color(0xFFFFB547); }
                    else if (s.status == "Absent") { badgeBg = const Color(0x1AEE5D50); badgeColor = const Color(0xFFEE5D50); }
                    else if (s.status == "Leave") { badgeBg = const Color(0x1A63B3ED); badgeColor = const Color(0xFF63B3ED); }

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(backgroundColor: const Color(0xFF4318FF), child: Text(s.name[0], style: const TextStyle(color: Colors.white))),
                      title: Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text("In: ${s.checkIn}${s.note.isNotEmpty ? ' · ' + s.note : ''}", style: const TextStyle(fontSize: 11, color: Color(0xFF8F9BBA))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _cycleStatus(s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(16)),
                              child: Text(s.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.note_alt_outlined, size: 16, color: Color(0xFF8F9BBA)),
                            onPressed: () => _editNote(s),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Submit Attendance Report"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4318FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setState(() => _submitted = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Attendance for ${_selectedSession.subject} submitted ($present present, $late late, $absent absent)")),
                        );
                      },
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

  Widget _buildCountCard(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(height: 4),
                Text("$count", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2559))),
                Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF8F9BBA))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
