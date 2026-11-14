import 'package:flutter/material.dart';

const Map<String, dynamic> matieresParClasseData = {
  "3eme": [
    {"nom": "Mathematiques", "icon": Icons.calculate, "color": Colors.blue},
    {"nom": "Physique-Chimie", "icon": Icons.science, "color": Colors.red},
    {"nom": "Francais", "icon": Icons.book, "color": Colors.green},
    {"nom": "Anglais", "icon": Icons.language, "color": Colors.purple},
    {"nom": "Histoire-Geographie", "icon": Icons.public, "color": Colors.orange},
    {"nom": "SVT", "icon": Icons.eco, "color": Colors.teal},
  ],
  "Tle A4": [
    {"nom": "Histoire-Geographie", "icon": Icons.public, "color": Colors.orange},
    {"nom": "Francais", "icon": Icons.book, "color": Colors.green},
    {"nom": "Philosophie", "icon": Icons.lightbulb, "color": Colors.deepOrange},
    {"nom": "Allemand", "icon": Icons.translate, "color": Colors.brown},
    {"nom": "Mathematiques", "icon": Icons.calculate, "color": Colors.blue},
  ],
  "Tle C": [
    {"nom": "Mathematiques", "icon": Icons.calculate, "color": Colors.blue},
    {"nom": "Physique-Chimie", "icon": Icons.science, "color": Colors.red},
    {"nom": "SVT", "icon": Icons.eco, "color": Colors.teal},
  ],
  "Tle D": [
    {"nom": "Mathematiques", "icon": Icons.calculate, "color": Colors.blue},
    {"nom": "Physique-Chimie", "icon": Icons.science, "color": Colors.red},
    {"nom": "Histoire-Geographie", "icon": Icons.public, "color": Colors.orange},
    {"nom": "SVT", "icon": Icons.eco, "color": Colors.teal},
  ],
  "Tle H": [
    {"nom": "Algorithmique", "icon": Icons.code, "color": Colors.blue},
    {"nom": "Programmation", "icon": Icons.computer, "color": Colors.green},
    {"nom": "Reseaux", "icon": Icons.wifi, "color": Colors.deepOrange},
    {"nom": "Mathematiques", "icon": Icons.calculate, "color": Colors.purple},
    {"nom": "Francais", "icon": Icons.book, "color": Colors.teal},
  ],
  "Tle G1": [
    {"nom": "Comptabilite", "icon": Icons.account_balance, "color": Colors.blue},
    {"nom": "Bureautique", "icon": Icons.laptop, "color": Colors.blueGrey},
    {"nom": "Francais", "icon": Icons.book, "color": Colors.green},
    {"nom": "Correspondance Commerciale", "icon": Icons.mail, "color": Colors.deepOrange},
  ],
  "Tle G2": [
    {"nom": "Comptabilite", "icon": Icons.account_balance, "color": Colors.blue},
    {"nom": "Gestion Financiere", "icon": Icons.bar_chart, "color": Colors.orange},
    {"nom": "Mathematique Financiere", "icon": Icons.calculate, "color": Colors.red},
    {"nom": "Francais", "icon": Icons.book, "color": Colors.green},
  ],
  "Autre classe": [
    {"nom": "Topographie", "icon": Icons.map, "color": Colors.deepOrange},
    {"nom": "Travaux Pratiques", "icon": Icons.build_circle, "color": Colors.teal},
  ],
};

const Map<String, dynamic> physiqueChimieStructData = {
  "3eme": {
    "Physique": [
      {
        "partie": "Partie 1 : Electricite",
        "chapitres": [
          "Chapitre 1 : Intensite du courant",
          "Chapitre 2 : Tension electrique",
          "Chapitre 3 : Puissance et energie",
          "Chapitre 4 : Conducteur ohmique",
          "Chapitre 5 : Associations de resistances",
        ],
      },
      {
        "partie": "Partie 2 : Mecanique",
        "chapitres": [
          "Chapitre 1 : La poulie et le treuil",
          "Chapitre 2 : Travail et puissance mecanique",
          "Chapitre 3 : Energie mecanique",
          "Chapitre 4 : Moteurs a piston",
        ],
      },
    ],
    "Chimie": [
      {
        "partie": "Partie 1 : Electrochimie",
        "chapitres": [
          "Chapitre 1 : Transformations electroniques du cuivre",
          "Chapitre 2 : Nature du courant dans les electrolytes",
          "Chapitre 3 : Pile electrochimique",
        ],
      },
    ],
  },
};

const Map<String, String> contenuCoursPCC = {
  "3eme_Physique_Partie 1 : Electricite_Chapitre 1 : Intensite du courant_Cours / Resumes":
      "COURS : IntensitÃ© du courant Ã©lectrique\n\n"
      "1. DÃ©finition\nL'intensitÃ© du courant Ã©lectrique mesure le dÃ©bit de l'Ã©lectricitÃ© dans un circuit.\n"
      "Elle se note I et s'exprime en AmpÃ¨res (A).\n\n"
      "2. Mesure\nOn utilise un ampÃ¨remÃ¨tre branchÃ© en sÃ©rie dans le circuit.",
};
