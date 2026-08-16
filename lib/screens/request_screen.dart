import 'package:flutter/material.dart';
import '../core/types.dart';
import '../core/mock_data.dart';

class RequestScreen extends StatefulWidget {
  final String kind; // "Leave" | "Permission"

  const RequestScreen({Key? key, required this.kind}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _fromController = TextEditingController(text: "2026-06-02");
  final _toController = TextEditingController(text: "2026-06-04");
  final _timeController = TextEditingController(text: "08:00");
  final _reasonController = TextEditingController();
  String? _attachment;

  @override
  Widget build(BuildContext context) {
    final list = mockRequestsData.where((r) => r.type == widget.kind).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New ${widget.kind} Request",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2559)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("From",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8F9BBA))),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _fromController,
                                decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.calendar_today, size: 16),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("To",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8F9BBA))),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _toController,
                                decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.calendar_today, size: 16),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.kind == "Permission") ...[
                      const SizedBox(height: 12),
                      const Text("Time",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8F9BBA))),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.access_time, size: 16),
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Text("Reason",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8F9BBA))),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: widget.kind == "Leave"
                            ? "Describe your leave reason…"
                            : "Reason for permission…",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Attachment (proof)",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8F9BBA))),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        setState(() => _attachment = "medical_note.pdf");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file,
                                size: 18, color: Color(0xFF8F9BBA)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _attachment ?? "Upload file (PDF / image)",
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF8F9BBA)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4318FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          if (_fromController.text.isEmpty ||
                              _reasonController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please fill in the required fields.")),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "${widget.kind} request submitted • awaiting approval")),
                          );
                          _reasonController.clear();
                        },
                        child: Text("Submit ${widget.kind} Request",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Recent Requests",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8F9BBA))),
            const SizedBox(height: 10),
            ...list.map((r) {
              Color toneColor = const Color(0xFFFFB547);
              Color toneBg = const Color(0x1AFFB547);
              if (r.status == RequestStatus.approved) {
                toneColor = const Color(0xFF05CD99);
                toneBg = const Color(0x1A05CD99);
              } else if (r.status == RequestStatus.rejected) {
                toneColor = const Color(0xFFEE5D50);
                toneBg = const Color(0x1AEE5D50);
              }

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r.id,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B2559))),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                color: toneBg,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              r.status.name.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: toneColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${r.from}${r.to != r.from ? ' → ' + r.to : ''}",
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF8F9BBA)),
                      ),
                      const SizedBox(height: 6),
                      Text(r.reason,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF1B2559))),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
