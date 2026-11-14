import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Choisissez votre profil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selectionnez votre profil pour continuer',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),

              // Espace Eleve
              _buildImageSpaceCard(
                title: 'Eleve',
                subtitle: 'Classes 3eme a Terminale',
                imagePath: 'assets/images/logos/logo_eleve.webp',
                fallbackColor: const Color(0xFF25D79B),
                onTap: () => context.go('/eleve/home'),
              ),
              const SizedBox(height: 16),

              // Espace Etudiant
              _buildImageSpaceCard(
                title: 'Etudiant',
                subtitle: 'Licence 1 a master 2',
                imagePath: 'assets/images/logos/logo_etudiant.jpg',
                fallbackColor: const Color(0xFF1C41DA),
                onTap: () => context.go('/etudiant/home'),
              ),
              const SizedBox(height: 16),

              // Espace Professionnel
              _buildImageSpaceCard(
                title: 'Professionnel',
                subtitle: 'Preparation aux concours',
                imagePath: 'assets/images/logos/logo_professionnel.jpeg',
                fallbackColor: const Color(0xFFD87922),
                onTap: () => context.go('/pro/home'),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4EFEA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2D6CB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFFB57C1E)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Vous beneficiez de 3 jours d'essai gratuit sur l'espace choisi !",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSpaceCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color fallbackColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: fallbackColor,
          boxShadow: [
            BoxShadow(
              color: fallbackColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: fallbackColor);
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.3),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
