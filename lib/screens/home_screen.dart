import 'package:flutter/material.dart';
import '../widgets/interactive_ring.dart';


// Importing necessary modules
import '../models/habit_event.dart';
import '../services/db_helper.dart';
import '../services/location_service.dart';
import '../services/habit_detection.dart';
import '../screens/overview.dart';

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
        title: const Text('Log Event'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter event name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('Save'),
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
      timestamp: DateTime.now(), // CHANGE: Set custom time for testing
      lat: pos?.latitude, // CHANGE: Replace with fake coordinates
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
    // CHANGE: Modify card color and shape here
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
            color: cardColor, // CHANGE: Set to different background color
            borderRadius: BorderRadius.circular(
              cardRadius,
            ), // CHANGE: Try 30 or 0
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ), // CHANGE: Icon size/color
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
      backgroundColor: Colors.black, // CHANGE: Background color of whole screen
      body: SafeArea(
        child: Column(
          children: [
            // === Upper Section: Mic Animation Header ===
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "Pie Equalizer", // You can rename it to "Pie is Listening..."
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === Custom Circular Equalizer UI ===
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glowing circle
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.red.withOpacity(0.6),
                                Colors.black,
                              ],
                              stops: const [0.3, 1],
                            ),
                          ),
                        ),

                        // Mid label (top)
                        const Positioned(
                          top: 8,
                          child: Text(
                            "Mid -3",
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),

                        // Bass label (left)
                        const Positioned(
                          left: 8,
                          top: 100,
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              "Bass +6",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ),

                        // Treble label (right)
                        const Positioned(
                          right: 8,
                          top: 100,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              "Treble +6",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ),

                        // Center circle
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),

                        // Knob (red dot)
                        Positioned(
                          top: 60, // adjust to move up/down
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Value at bottom
                        const Positioned(
                          bottom: 10,
                          child: Text(
                            "-3",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // === Lower Section: Feature Cards Grid ===
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2, // CHANGE: Try 1 or 3 columns
                  mainAxisSpacing: 12, // CHANGE: Try larger spacing
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2, // CHANGE: Try 1.0 for square cards
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
                        // CHANGE: Navigate to insights screen
                      },
                    ),
                    featureCard(
                      icon: Icons.timeline,
                      title: "Event History",
                      subtitle: "${_events.length} events", // Dynamic subtitle
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OverviewScreen(),
                          ), // CHANGE: Navigate to history screen
                        );
                      },
                    ),
                    featureCard(
                      icon: Icons.bar_chart,
                      title: "Trends",
                      subtitle: "Weekly / Monthly",
                      onTap: () {
                        // CHANGE: Navigate to trends visualization
                      },
                    ),
                    featureCard(
                      icon: Icons.location_on,
                      title: "Location",
                      subtitle: "Track Surroundings",
                      onTap: () {
                        // CHANGE: Navigate to map screen
                      },
                    ),
                    featureCard(
                      icon: Icons.settings,
                      title: "Custom Controls",
                      subtitle: "Personalised",
                      onTap: () {
                        // CHANGE: Navigate to settings/preferences
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
