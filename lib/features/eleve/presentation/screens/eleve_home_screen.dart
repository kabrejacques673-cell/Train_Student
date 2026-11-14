import 'package:flutter/material.dart';
import 'package:train_student/widgets/assistant_ia_bar.dart';
import 'chapitres_screen.dart';
import 'physique_chimie_histoire_geo_screen.dart';
import 'eleve_data.dart';

class EleveHomeScreen extends StatefulWidget {
  const EleveHomeScreen({super.key});

  @override
  State<EleveHomeScreen> createState() => _EleveHomeScreenState();
}

class _EleveHomeScreenState extends State<EleveHomeScreen> {
  String selectedClasse = "3eme";

  final List<String> classes = ["3eme", "Tle A4", "Tle C", "Tle D", "Tle H", "Tle G1", "Tle G2", "Autre classe"];

  @override
  Widget build(BuildContext context) {
    final List<dynamic> matieresActuelles = matieresParClasseData[selectedClasse] ?? [];

    return Scaffold(
      bottomNavigationBar: AssistantIaBar(espace: 'eleve', niveau: selectedClasse, couleur: const Color(0xFF00B074)),
      appBar: AppBar(
        title: const Text('Espace Eleve (BEPC / BAC)'),
        backgroundColor: const Color(0xFF00B074),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choisissez votre classe :',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final classe = classes[index];
                      final isSelected = classe == selectedClasse;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(classe),
                          selected: isSelected,
                          selectedColor: const Color(0xFF00B074),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedClasse = classe;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: matieresActuelles.length,
              itemBuilder: (context, index) {
                final card = matieresActuelles[index] as Map<String, dynamic>;
                final nomMatiere = card['nom'] as String;
                final couleurMatiere = card['color'] as Color;
                final iconeMatiere = card['icon'] as IconData;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: couleurMatiere.withValues(alpha: 0.2),
                        child: Icon(iconeMatiere, color: couleurMatiere),
                      ),
                      title: Text(nomMatiere, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Programme officiel - $selectedClasse'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        if (nomMatiere == "Physique-Chimie" || nomMatiere == "Histoire-Geographie") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhysiqueChimieHistoireGeoScreen(
                                sousMatiere: nomMatiere,
                                classe: selectedClasse,
                                couleur: couleurMatiere,
                                icone: iconeMatiere,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChapitresScreen(
                                sousMatiere: nomMatiere,
                                classe: selectedClasse,
                                couleur: couleurMatiere,
                                icone: iconeMatiere,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
