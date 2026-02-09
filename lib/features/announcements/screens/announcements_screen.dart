import 'package:flutter/material.dart';
import '../../../widgets/cards/announcement_card.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Announcements")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            AnnouncementCard(
              title: "Reminder: Project Deadlines",
              description:
                  "Make sure all deliverables are submitted before the deadline.",
            ),
            AnnouncementCard(
              title: "Upcoming Industry Talk",
              description:
                  "Join us this Friday for an industry talk on mobile development.",
            ),
            AnnouncementCard(
              title: "Update for All Students",
              description:
                  "New learning materials have been added to the portal.",
            ),
          ],
        ),
      ),
    );
  }
}
