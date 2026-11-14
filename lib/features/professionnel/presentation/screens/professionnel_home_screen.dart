import "package:flutter/material.dart";
import "package:train_student/screens/ai_tutor_screen.dart";
import "package:go_router/go_router.dart";
import "../../data/concours_data.dart";
import "cv_professionnel_screen.dart";
import "concours_list_screen.dart";
import "../../../abonnement/presentation/screens/abonnement_screen.dart";

class ProfessionnelHomeScreen extends StatefulWidget {
  const ProfessionnelHomeScreen({super.key});

  @override
  State<ProfessionnelHomeScreen> createState() => _ProfessionnelHomeScreenState();
}

class _ProfessionnelHomeScreenState extends State<ProfessionnelHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 3 ? null : AppBar(
        backgroundColor: Colors.orange.shade600,
        title: const Text("Espace Professionnel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () => context.go("/login")),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildAccueil(),
          const CvProfessionnelScreen(),
          _buildProfil(),
          const AiTutorScreen(chapterTitle: "Assistant IA", chapterText: "", level: "Concours et formation", space: "professionnel"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: "Mon CV"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), activeIcon: Icon(Icons.smart_toy), label: "Assistant IA"),
        ],
      ),
    );
  }

  Widget _buildAccueil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade600]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Prepare tes concours", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Selectionne ton niveau d etudes", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("Niveaux d etudes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...NiveauDiplome.values.map((niveau) {
            final nbConcours = ConcoursData.parNiveau(niveau).length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LevelCard(
                titre: niveau.label,
                description: "$nbConcours concours disponibles",
                icon: niveau.icon,
                color: niveau.color,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConcoursListScreen(niveau: niveau))),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfil() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(radius: 48, backgroundColor: Colors.orange.shade600, child: const Icon(Icons.person, size: 48, color: Colors.white)),
          const SizedBox(height: 16),
          const Text("Espace Professionnel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.subscriptions_outlined),
            title: const Text("Mon abonnement"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AbonnementScreen(espace: "professionnel"))),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text("Changer d espace"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.go("/role-selection"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Se deconnecter", style: TextStyle(color: Colors.red)),
            onTap: () => context.go("/login"),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String titre, description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _LevelCard({required this.titre, required this.description, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.7), color]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(description, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9))),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

