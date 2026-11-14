
import "package:flutter/material.dart";
import "../../data/cours_etudiant_data.dart";

class ModuleContenuScreen extends StatelessWidget {
  final String moduleName;
  final String section;
  final Color couleur;

  const ModuleContenuScreen({
    super.key,
    required this.moduleName,
    required this.section,
    required this.couleur,
  });

  void _agrandirFigure(BuildContext context, String chemin) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Center(
                child: Image.asset(
                  chemin,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) =>
                  const Text(
                    "Figure introuvable",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cours = trouverCours(moduleName, section);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: couleur,
        foregroundColor: Colors.white,
        title: Text(moduleName),
      ),
      body: cours == null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            "$section : contenu bientôt disponible.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            cours.titre,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${cours.blocs.length} parties du cours",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          ...cours.blocs.map((bloc) {
            return Card(
              margin: const EdgeInsets.only(bottom: 18),
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bloc.titre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: couleur,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      bloc.texte,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),

                    if (bloc.figure != null) ...[
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _agrandirFigure(
                          context,
                          bloc.figure!,
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              bloc.figure!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              errorBuilder:
                                  (context, error, stack) =>
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  "Figure introuvable",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Toucher la figure pour agrandir",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
