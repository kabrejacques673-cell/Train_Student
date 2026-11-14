import 'package:flutter/material.dart';

const Map<String, Map<String, List<String>>> chapitresParMatiere = {
  "Mathematiques_3eme": {
    "chapitres": [
      "Chapitre 1 : Nombres relatifs",
      "Chapitre 2 : Calcul litteral",
      "Chapitre 3 : Equations du premier degre",
      "Chapitre 4 : Inequations",
      "Chapitre 5 : Theoreme de Thales",
      "Chapitre 6 : Trigonometrie",
      "Chapitre 7 : Statistiques",
      "Chapitre 8 : Probabilites",
    ],
  },
  "Francais_3eme": {
    "chapitres": [
      "Chapitre 1 : Grammaire",
      "Chapitre 2 : Conjugaison",
      "Chapitre 3 : Orthographe",
      "Chapitre 4 : Litterature",
      "Chapitre 5 : Expression ecrite",
    ],
  },
  "Anglais_3eme": {
    "chapitres": [
      "Chapitre 1 : Vocabulaire",
      "Chapitre 2 : Grammaire Anglaise",
      "Chapitre 3 : Conversation",
      "Chapitre 4 : Textes et lectures",
    ],
  },
  "SVT_3eme": {
    "chapitres": [
      "Chapitre 1 : Biologie Generale",
      "Chapitre 2 : Ecologie",
      "Chapitre 3 : Genetique",
      "Chapitre 4 : Sante et Hygiene",
    ],
  },
};

final Map<String, String> coursContent = {
  "Mathematiques_3eme_Chapitre 1 : Nombres relatifs_Cours / Resumes":
    "COURS : Nombres relatifs\n\n"
    "1. Definition\nLes nombres relatifs sont les nombres positifs et negatifs.\n"
    "Exemples : -5, -3, 0, +2, +7\n\n"
    "2. Comparaison\n- Un nombre positif est toujours superieur a un nombre negatif\n\n"
    "3. Operations\nAddition : (-3) + (+5) = +2\nSoustraction : (+4) - (+7) = -3\n\n"
    "Regle des signes :\n(+) x (+) = (+)\n(-) x (-) = (+)\n(+) x (-) = (-)\n(-) x (+) = (-)",
  "Mathematiques_3eme_Chapitre 1 : Nombres relatifs_Exercices + Corriges":
    "EXERCICES : Nombres relatifs\n\nExercice 1 :\nCalculer :\n"
    "a) (-3) + (+7) = ?\nb) (+5) - (-2) = ?\nc) (-4) x (+3) = ?\nd) (-12) / (-4) = ?\n\n"
    "CORRIGES :\na) +4\nb) +7\nc) -12\nd) +3",
  "Mathematiques_3eme_Chapitre 1 : Nombres relatifs_Devoirs":
    "DEVOIR : Nombres relatifs\n\nDevoir 1 :\n"
    "1) Ranger dans l ordre croissant : -5, +3, -1, 0, +7, -8\n"
    "2) Calculer : (-2) + (-3) - (+1) + (+6)\n"
    "3) Calculer : (-3) x (+4) / (-2)",
};

class ChapitresScreen extends StatelessWidget {
  final String sousMatiere, classe;
  final Color couleur;
  final IconData icone;

  const ChapitresScreen({
    Key? key,
    required this.sousMatiere,
    required this.classe,
    required this.couleur,
    required this.icone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = "${sousMatiere}_$classe";
    final data = chapitresParMatiere[key];
    final chapitres = data?["chapitres"] ?? ["Contenu a venir"];

    return Scaffold(
      appBar: AppBar(backgroundColor: couleur, title: Text(sousMatiere)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: couleur.withOpacity(0.1),
            child: Row(children: [
              Icon(icone, color: couleur, size: 28),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(sousMatiere, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: couleur)),
                Text("Classe : $classe"),
                Text("${chapitres.length} chapitres"),
              ]),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chapitres.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(chapitres[index]),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SectionsScreen(
                      chapitre: chapitres[index],
                      matiere: sousMatiere,
                      classe: classe,
                      couleur: couleur,
                      icone: icone,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionsScreen extends StatelessWidget {
  final String chapitre, matiere, classe;
  final Color couleur;
  final IconData icone;

  const SectionsScreen({
    Key? key,
    required this.chapitre,
    required this.matiere,
    required this.classe,
    required this.couleur,
    required this.icone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = [
      {"titre": "Cours / Resumes", "icon": Icons.menu_book_outlined, "color": Colors.blue},
      {"titre": "Exercices + Corriges", "icon": Icons.edit_note_outlined, "color": Colors.green},
      {"titre": "Devoirs", "icon": Icons.assignment_outlined, "color": Colors.orange},
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: couleur, title: Text(chapitre)),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return ListTile(
            leading: Icon(section["icon"] as IconData, color: section["color"] as Color),
            title: Text(section["titre"] as String),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CoursContentScreen(
                  chapitre: chapitre,
                  matiere: matiere,
                  classe: classe,
                  section: section["titre"] as String,
                  couleur: couleur,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CoursContentScreen extends StatelessWidget {
  final String chapitre, matiere, classe, section;
  final Color couleur;

  const CoursContentScreen({
    Key? key,
    required this.chapitre,
    required this.matiere,
    required this.classe,
    required this.section,
    required this.couleur,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentKey = "${matiere}_${classe}_${chapitre}_$section";
    final contenu = coursContent[contentKey] ?? "Contenu en cours de redaction...";

    return Scaffold(
      appBar: AppBar(backgroundColor: couleur, title: Text(section)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chapitre, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: couleur)),
            const SizedBox(height: 20),
            Text(contenu, style: const TextStyle(fontSize: 15, height: 1.8)),
          ],
        ),
      ),
    );
  }
}
