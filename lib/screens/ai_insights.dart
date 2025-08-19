import 'package:flutter/material.dart';

class AiInsightsScreen extends StatelessWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          Icon(Icons.settings, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Top Date Selector ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final isToday = index == 1; // mock "today"
                return CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      isToday ? Colors.red : Colors.white.withOpacity(0.2),
                  child: Text(
                    "${21 + index}",
                    style: TextStyle(
                      color: isToday ? Colors.white : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // === AI Message ===
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Hey, today is your focus training day. If you feel tired, "
                "please remember to slow down and adjust your pace.",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),

            // === Progress Section ===
            const Text(
              "Your progress",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Sessions completed",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 8),
                        Text("7/40",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Progress",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 8),
                        Text("17%",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // === Dot Graph ===
            Container(
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  7,
                  (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      6,
                      (dotIndex) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: dotIndex < (index + 2) % 6
                              ? Colors.red
                              : Colors.white24,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // === Goal Section ===
            const Text(
              "Your goal",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Course length", style: TextStyle(color: Colors.white70)),
                  Text("11 weeks", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}