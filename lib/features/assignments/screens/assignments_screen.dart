import 'package:flutter/material.dart';
import '../../../widgets/cards/assignment_card.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assignments")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            AssignmentCard(
              title: "Assignment 1",
              dueDate: "Feb 26",
            ),
            AssignmentCard(
              title: "Assignment 2",
              dueDate: "Feb 28",
            ),
            AssignmentCard(
              title: "Group Project (Flutter)",
              dueDate: "Mar 2",
            ),
          ],
        ),
      ),
    );
  }
}
