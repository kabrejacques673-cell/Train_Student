import 'package:flutter/material.dart';
import 'eleve_data.dart';

class PhysiqueChimieHistoireGeoScreen extends StatelessWidget {
  final String sousMatiere, classe;
  final Color couleur;
  final IconData icone;

  const PhysiqueChimieHistoireGeoScreen({
    super.key,
    required this.sousMatiere,
    required this.classe,
    required this.couleur,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    final isPhysiqueChimie = sousMatiere.contains("Physique");
    final sectionsList = isPhysiqueChimie ? ["Physique", "Chimie"] : ["Histoire", "Geographie"];

    return Scaffold(
      appBar: AppBar(backgroundColor: couleur, title: Text(sousMatiere)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icone, color: couleur, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sousMatiere, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: couleur)),
                    Text("Classe : $classe", style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Domaines principaux :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...sectionsList.map((domaine) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: couleur.withValues(alpha: 0.2),
                  child: Icon(domaine == "Physique" ? Icons.bolt : Icons.science, color: couleur),
                ),
                title: Text(domaine, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Programme officiel de $classe"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PartiesScreen(
                        domaine: domaine,
                        classe: classe,
                        couleur: couleur,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PartiesScreen extends StatelessWidget {
  final String domaine, classe;
  final Color couleur;

  const PartiesScreen({
    super.key,
    required this.domaine,
    required this.classe,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    final classeMap = physiqueChimieStructData[classe] as Map<String, dynamic>?;
    final partiesData = classeMap?[domaine] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(backgroundColor: couleur, title: Text(domaine)),
      body: partiesData.isEmpty
          ? const Center(child: Text("Contenu bientôt disponible pour cette classe."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: partiesData.length,
              itemBuilder: (context, index) {
                final partieObj = partiesData[index] as Map<String, dynamic>;
                final nomPartie = partieObj["partie"] as String;
                final chapitres = List<String>.from(partieObj["chapitres"] ?? []);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    title: Text(nomPartie, style: TextStyle(fontWeight: FontWeight.bold, color: couleur)),
                    subtitle: Text("${chapitres.length} chapitres"),
                    children: chapitres.map((chapitre) {
                      return ListTile(
                        title: Text(chapitre, style: const TextStyle(fontSize: 14)),
                        leading: const Icon(Icons.bookmark_border, size: 20),
                        trailing: const Icon(Icons.chevron_right, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SectionsPCCScreen(
                                domaine: domaine,
                                partie: nomPartie,
                                chapitre: chapitre,
                                classe: classe,
                                couleur: couleur,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}

class SectionsPCCScreen extends StatelessWidget {
  final String domaine, partie, chapitre, classe;
  final Color couleur;

  const SectionsPCCScreen({
    super.key,
    required this.domaine,
    required this.partie,
    required this.chapitre,
    required this.classe,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      {"titre": "Cours / Resumes", "icon": Icons.menu_book_outlined, "color": Colors.blue},
      {"titre": "Exercices + Corriges", "icon": Icons.edit_note_outlined, "color": Colors.green},
      {"titre": "Devoirs", "icon": Icons.assignment_outlined, "color": Colors.orange},
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: couleur, title: Text(chapitre, style: const TextStyle(fontSize: 16))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final sec = sections[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(sec["icon"] as IconData, color: sec["color"] as Color),
              title: Text(sec["titre"] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContenuPCCScreen(
                      domaine: domaine,
                      partie: partie,
                      chapitre: chapitre,
                      classe: classe,
                      section: sec["titre"] as String,
                      couleur: couleur,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ContenuPCCScreen extends StatelessWidget {
  final String domaine, partie, chapitre, classe, section;
  final Color couleur;

  const ContenuPCCScreen({
    super.key,
    required this.domaine,
    required this.partie,
    required this.chapitre,
    required this.classe,
    required this.section,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    final key = "${classe}_${domaine}_${partie}_${chapitre}_$section";
    final texteContenu = contenuCoursPCC[key] ?? "Contenu détaillé en cours de rédaction pour ce chapitre...";

    return Scaffold(
      appBar: AppBar(backgroundColor: couleur, title: Text(section)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(partie, style: TextStyle(color: couleur, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(chapitre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 30),
            Text(texteContenu, style: const TextStyle(fontSize: 15, height: 1.8)),
          ],
        ),
      ),
    );
  }
}