import 'package:flutter/material.dart';

// Importing necessary modules
import '../models/habit_event.dart';
import '../services/db_helper.dart';
import '../services/location_service.dart';
import '../services/habit_detection.dart';
import '../screens/overview.dart';
import '../widgets/interactive_ring.dart'; // ✅ new import
import '../screens/ai_insights.dart'; // ✅ new import

/// The main screen users interact with.
/// Displays logging options, AI insights, and recent habits.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of all habit events retrieved from the database
  List<HabitEvent> _events = [];

  // List of identified habits from the habit detector
  List<String> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Loads events when the screen initializes
  }

  /// Fetches all habit events from the database
  Future<void> _loadEvents() async {
    final events = await DBHelper.getEvents();
    setState(() => _events = events);
  }

  /// Handles logging a new habit event
  Future<void> _logEvent() async {
    final nameController = TextEditingController();

    // Prompt user for event name
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black, // dark background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Event', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter event name',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white), // or any color you want
            ),
          ),
        ],
      ),
    );

    // If input is empty or cancelled, do nothing
    if (name == null || name.isEmpty) return;

    // Get user's current position
    final pos = await getCurrentPosition();

    // Create a new HabitEvent
    final event = HabitEvent(
      name: name,
      timestamp: DateTime.now(),
      lat: pos?.latitude,
      lng: pos?.longitude,
    );

    // Save the event to the database
    await DBHelper.insertEvent(event);

    // Reload events and detect habits
    final events = await DBHelper.getEvents();
    final habits = HabitDetector.findHabits(events);
    setState(() {
      _events = events;
      _habits = habits;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = const Color(0xFF1C1C1E);
    final double cardRadius = 14;

    /// Template for each feature card
    Widget featureCard({
      required IconData icon,
      required String title,
      required String subtitle,
      VoidCallback? onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // === Upper Section: Interactive Ring ===
            const InteractiveRing(),

            const SizedBox(height: 10),

            // === Lower Section: Feature Cards Grid ===
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    featureCard(
                      icon: Icons.psychology,
                      title: "Log Event",
                      subtitle: "Track New Habit",
                      onTap: _logEvent,
                    ),
                    featureCard(
                      icon: Icons.auto_awesome,
                      title: "AI Insights",
                      subtitle: "Personal Suggestions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AiInsightsScreen(),
                          ),
                        );
                      },
                    ),
                    featureCard(
                      icon: Icons.timeline,
                      title: "Event History",
                      subtitle: "${_events.length} events",
                      onTap: () {},
                    ),
                    featureCard(
                      icon: Icons.bar_chart,
                      title: "Trends",
                      subtitle: "Weekly / Monthly",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OverviewScreen(),
                          ),
                        );
                      },
                    ),
                    featureCard(
                      icon: Icons.location_on,
                      title: "Location",
                      subtitle: "Track Surroundings",
                      onTap: () {
                        // TODO: Navigate to map screen
                      },
                    ),
                    featureCard(
                      icon: Icons.settings,
                      title: "Custom Controls",
                      subtitle: "Personalised",
                      onTap: () {
                        // TODO: Navigate to settings/preferences
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
