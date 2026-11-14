import 'package:flutter/material.dart';
import 'package:train_student/screens/ai_tutor_screen.dart';

class AssistantIaBar extends StatelessWidget {
  final String espace;
  final String niveau;
  final Color couleur;

  const AssistantIaBar({
    super.key,
    required this.espace,
    required this.niveau,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      indicatorColor: couleur.withValues(alpha: 0.2),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: "Cours"),
        NavigationDestination(icon: Icon(Icons.smart_toy_outlined), label: "Assistant IA"),
      ],
      onDestinationSelected: (i) {
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AiTutorScreen(
                chapterTitle: "Assistant IA",
                chapterText: "",
                level: niveau,
                space: espace,
              ),
            ),
          );
        }
      },
    );
  }
}