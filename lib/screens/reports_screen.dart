import 'package:flutter/material.dart';
import '../core/mock_data.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _scope = "class";
  final _fromController = TextEditingController(text: "05/01/2026");
  final _toController = TextEditingController(text: "05/29/2026");

  void _exportFile(String kind) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$kind report generated (KH/EN bilingual)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF201B3E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1B4B);
    final subtitleColor =
        isDark ? const Color(0xFFA0AEC0) : const Color(0xFF8F9BBA);
    final inputBgColor =
        isDark ? const Color(0xFF2E2657) : const Color(0xFFF0EEFF);
    final pillBgColor =
        isDark ? const Color(0xFF2E2657) : const Color(0xFFF7F5FF);
    final pillBorderColor =
        isDark ? const Color(0xFF3B326B) : const Color(0xFFE4E0FF);

    final gradientDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                const Color(0xFF14112A),
                const Color(0xFF191535),
                const Color(0xFF211A42)
              ]
            : [
                const Color(0xFFE4E0FF),
                const Color(0xFFEFE8FF),
                const Color(0xFFFAE8F4)
              ],
      ),
    );

    return Container(
      decoration: gradientDecoration,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Generate Report",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 16),
                  Text("Scope",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: inputBgColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _scope,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: subtitleColor),
                        dropdownColor: cardColor,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: titleColor),
                        items: const [
                          DropdownMenuItem(
                              value: "class", child: Text("My Class")),
                          DropdownMenuItem(
                              value: "department", child: Text("Department")),
                          DropdownMenuItem(
                              value: "individual",
                              child: Text("Individual Student")),
                        ],
                        onChanged: (v) => setState(() => _scope = v ?? "class"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: titleColor)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 2),
                              decoration: BoxDecoration(
                                color: inputBgColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: TextField(
                                controller: _fromController,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: titleColor),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.calendar_today_rounded,
                                      size: 16, color: subtitleColor),
                                  suffixIconConstraints:
                                      const BoxConstraints(minWidth: 20),
                                ),
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
                            Text("To",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: titleColor)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 2),
                              decoration: BoxDecoration(
                                color: inputBgColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: TextField(
                                controller: _toController,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: titleColor),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.calendar_today_rounded,
                                      size: 16, color: subtitleColor),
                                  suffixIconConstraints:
                                      const BoxConstraints(minWidth: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: pillBorderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Preview — % present",
                            style:
                                TextStyle(fontSize: 12, color: subtitleColor)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 90,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: weeklyTrendData.map((d) {
                              final pct = (d["present"] as int);
                              return Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: pct * 0.65,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B5BF6),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(d["day"].toString(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: subtitleColor)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _exportFile("PDF"),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: pillBorderColor),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.picture_as_pdf_outlined,
                                    size: 18, color: Color(0xFF8B5BF6)),
                                SizedBox(width: 8),
                                Text("PDF",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8B5BF6))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _exportFile("Excel"),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: pillBorderColor),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.table_chart_outlined,
                                    size: 18, color: Color(0xFF8B5BF6)),
                                SizedBox(width: 8),
                                Text("Excel",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8B5BF6))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Exports are bilingual — ខ្មែរ above, English below",
                      style: TextStyle(fontSize: 11, color: subtitleColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recent Exports",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 10),
                  ...[
                    "attendance_may_2026.pdf",
                    "class_4B_weekly.xlsx",
                    "absences_q2.pdf"
                  ].map((f) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(f,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: titleColor)),
                          trailing: IconButton(
                            icon: const Icon(Icons.download_rounded,
                                size: 20, color: Color(0xFF8B5BF6)),
                            onPressed: () => _exportFile("Download"),
                          ),
                        ),
                        Divider(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF2F2853)
                                : Colors.grey.shade100),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
