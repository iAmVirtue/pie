import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My devices   Fitness",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                    radius: 18,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Top Card (Track Progress)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's activities",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Track Progress (Oval)
                    SizedBox(
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer Track
                          Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[800]!,
                                width: 8,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          // Progress Overlay (mock)
                          Positioned(
                            child: Container(
                              width: 200,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 8,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Activity Data
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _ActivityStat(color: Colors.red, label: "Calories (kcal)", value: "715/300"),
                        _ActivityStat(color: Colors.orange, label: "Exercise (min)", value: "72/40"),
                        _ActivityStat(color: Colors.blue, label: "Stand (time)", value: "8/12"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Steps Counter
              const Text(
                "Steps 16429/10000",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Grid Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: const [
                  _MetricCard(
                    title: "Exercise",
                    subtitle: "15:7",
                    icon: Icons.fitness_center,
                  ),
                  _MetricCard(
                    title: "Recent exercise",
                    subtitle: "341 kcal\n7.53 km   32 min",
                    icon: Icons.directions_run,
                  ),
                  _MetricCard(
                    title: "Heart rate",
                    subtitle: "92 bpm",
                    icon: Icons.favorite,
                  ),
                  _MetricCard(
                    title: "Blood oxygen",
                    subtitle: "96%",
                    icon: Icons.bloodtype,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityStat extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _ActivityStat({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}