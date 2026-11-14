import 'cours_aop_etudiant.dart';

class BlocCours {
  final String titre;
  final String texte;
  final String? figure;

  const BlocCours({
    required this.titre,
    required this.texte,
    this.figure,
  });
}

class CoursEtudiant {
  final String titre;
  final List<BlocCours> blocs;

  const CoursEtudiant({
    required this.titre,
    required this.blocs,
  });
}

const String _dossierFigures =
    "assets/cours/etudiant/electronique_analogique_2/figures/";

final Map<String, CoursEtudiant> coursEtudiant = {
  "Electronique Analogique 2|cours": CoursEtudiant(
    titre: "Amplificateur opérationnel (AOP)",
    blocs: [
      BlocCours(
        titre: "1. Généralités sur l'AOP",
        texte:
        "L'amplificateur opérationnel est un amplificateur différentiel "
            "à très grand gain. Il possède deux entrées : l'entrée inverseuse "
            "(-) et l'entrée non inverseuse (+), ainsi qu'une sortie.\n\n"
            "Sa tension de sortie dépend de la différence entre les deux "
            "tensions d'entrée : Vs = A(V+ - V-).\n\n"
            "Dans le modèle idéal, le gain est très grand, les courants "
            "d'entrée sont nuls et l'impédance de sortie est nulle.",
        figure: "${_dossierFigures}figure-01.png",
      ),

      BlocCours(
        titre: "2. Le montage suiveur",
        texte:
        "Le suiveur est un montage dans lequel la sortie est reliée "
            "directement à l'entrée inverseuse.\n\n"
            "Sa tension de sortie est égale à la tension d'entrée : "
            "Vs = Ve.\n\n"
            "Son rôle principal est l'adaptation d'impédance.",
        figure: "${_dossierFigures}figure-02.png",
      ),

      BlocCours(
        titre: "3. Le montage inverseur",
        texte:
        "Le montage inverseur utilise une résistance d'entrée R1 "
            "et une résistance de contre-réaction R2.\n\n"
            "Sa tension de sortie est : Vs = -(R2/R1) × Ve.\n\n"
            "Le signal de sortie est inversé par rapport au signal d'entrée.",
        figure: "${_dossierFigures}figure-03.png",
      ),

      BlocCours(
        titre: "4. Le montage non inverseur",
        texte:
        "Le signal d'entrée est appliqué sur l'entrée non inverseuse.\n\n"
            "Le gain en tension est : G = 1 + R2/R1.\n\n"
            "La tension de sortie est : Vs = (1 + R2/R1) × Ve.\n\n"
            "Le signal de sortie conserve la même phase que le signal d'entrée.",
        figure: "${_dossierFigures}figure-04.png",
      ),

      BlocCours(
        titre: "5. Le sommateur inverseur",
        texte:
        "Le sommateur inverseur permet d'additionner plusieurs tensions "
            "d'entrée à l'aide de résistances.\n\n"
            "Sa relation générale est :\n"
            "Vs = -Rf × (V1/R1 + V2/R2 + V3/R3).\n\n"
            "Les résistances permettent de donner un poids différent "
            "à chaque tension d'entrée.",
        figure: "${_dossierFigures}figure-05.png",
      ),

      BlocCours(
        titre: "6. Le soustracteur",
        texte:
        "Le soustracteur est un amplificateur différentiel. "
            "Il permet d'amplifier la différence entre deux tensions.\n\n"
            "Lorsque les rapports des résistances sont adaptés :\n"
            "Vs = (R2/R1) × (V2 - V1).\n\n"
            "Il est utilisé pour mesurer une différence de potentiel.",
        figure: "${_dossierFigures}figure-06.png",
      ),

      BlocCours(
        titre: "7. Le montage intégrateur",
        texte:
        "L'intégrateur utilise un condensateur dans la boucle "
            "de contre-réaction.\n\n"
            "Sa relation idéale est :\n"
            "Vs(t) = -1/(RC) × ∫Ve(t)dt.\n\n"
            "Il permet d'obtenir une tension de sortie proportionnelle "
            "à l'intégrale du signal d'entrée.",
        figure: "${_dossierFigures}figure-07.png",
      ),

      BlocCours(
        titre: "8. Le montage dérivateur",
        texte:
        "Le dérivateur produit une tension de sortie liée à la "
            "variation du signal d'entrée.\n\n"
            "Sa relation idéale est :\n"
            "Vs = -RC × dVe/dt.\n\n"
            "Il est sensible au bruit électrique.",
        figure: "${_dossierFigures}figure-08.png",
      ),

      BlocCours(
        titre: "9. Le comparateur",
        texte:
        "Le comparateur fonctionne sans contre-réaction négative.\n\n"
            "Il compare les tensions appliquées à ses deux entrées.\n\n"
            "La sortie prend une valeur de saturation positive ou négative "
            "selon le signe de la différence entre les entrées.",
        figure: "${_dossierFigures}figure-09.png",
      ),

      BlocCours(
        titre: "10. Le trigger de Schmitt",
        texte:
        "Le trigger de Schmitt est un comparateur avec réaction positive.\n\n"
            "Il possède deux seuils de commutation : un seuil haut "
            "et un seuil bas.\n\n"
            "L'écart entre ces deux seuils est appelé hystérésis. "
            "Ce montage permet de limiter les commutations parasites.",
        figure: "${_dossierFigures}figure-10.png",
      ),

      BlocCours(
        titre: "11. Le filtre passe-bas actif",
        texte:
        "Le filtre passe-bas laisse passer les basses fréquences "
            "et atténue les hautes fréquences.\n\n"
            "Sa fréquence de coupure du premier ordre est :\n"
            "fc = 1/(2πR2C).\n\n"
            "Au-delà de la fréquence de coupure, son gain diminue.",
        figure: "${_dossierFigures}figure-11.png",
      ),

      BlocCours(
        titre: "12. Le filtre passe-haut actif",
        texte:
        "Le filtre passe-haut laisse passer les hautes fréquences "
            "et atténue les basses fréquences.\n\n"
            "Sa fréquence de coupure du premier ordre est :\n"
            "fc = 1/(2πR1C).\n\n"
            "En continu, le condensateur bloque le signal.",
        figure: "${_dossierFigures}figure-12.png",
      ),

      BlocCours(
        titre: "13. Réponses en fréquence",
        texte:
        "La réponse en fréquence permet d'observer l'évolution du gain "
            "d'un filtre selon la fréquence du signal appliqué.\n\n"
            "Elle permet notamment de distinguer les zones de passage "
            "et les zones d'atténuation des filtres.",
        figure: "${_dossierFigures}figure-13.png",
      ),

      BlocCours(
        titre: "14. Le filtre de Sallen-Key",
        texte:
        "Le filtre de Sallen-Key est un filtre actif du deuxième ordre.\n\n"
            "Il peut être utilisé comme filtre passe-bas. "
            "Sa fréquence propre dépend des résistances et des condensateurs "
            "du montage.\n\n"
            "Le facteur de qualité caractérise la réponse du filtre.",
        figure: "${_dossierFigures}figure-14.png",
      ),

      BlocCours(
        titre: "15. Le multivibrateur astable",
        texte:
        "Le multivibrateur astable est un oscillateur à relaxation.\n\n"
            "Il produit un signal périodique sans nécessiter de signal "
            "de déclenchement extérieur.\n\n"
            "Sa période dépend notamment des composants R et C "
            "et du seuil de commutation.",
        figure: "${_dossierFigures}figure-15.png",
      ),

      BlocCours(
        titre: "16. Signal de sortie de l'astable",
        texte:
        "Le fonctionnement de l'astable provoque des commutations "
            "périodiques de la tension de sortie.\n\n"
            "L'observation des formes d'onde permet de comprendre "
            "les phases de charge et de décharge du condensateur.",
        figure: "${_dossierFigures}figure-16.png",
      ),

      BlocCours(
        titre: "17. Amplificateur d'instrumentation",
        texte:
        "L'amplificateur d'instrumentation permet d'amplifier "
            "une faible différence de tension entre deux entrées.\n\n"
            "Il utilise trois amplificateurs opérationnels dans "
            "le montage présenté dans le cours.\n\n"
            "Son gain peut être réglé à l'aide de la résistance RG.",
        figure: "${_dossierFigures}figure-17.png",
      ),

      BlocCours(
        titre: "18. Limites réelles de l'AOP",
        texte:
        "Un amplificateur opérationnel réel possède plusieurs limites.\n\n"
            "Le produit gain-bande (GBW) limite la bande passante "
            "lorsque le gain augmente.\n\n"
            "La vitesse de balayage (Slew Rate) limite la rapidité "
            "de variation de la tension de sortie.\n\n"
            "La tension d'offset et les courants de polarisation "
            "peuvent également introduire des erreurs.",
        figure: "${_dossierFigures}figure-18.png",
      ),
    ],
  ),
};

String _typeSection(String s) {
  final t = s.toLowerCase();
  if (t.startsWith("cours")) return "cours";
  if (t.startsWith("td") || t.startsWith("exercice")) return "td";
  if (t.startsWith("devoir")) return "devoirs";
  return t;
}

CoursEtudiant? trouverCours(String module, String section) {
  final cle = "$module|${_typeSection(section)}";
  if (cle == "Electronique Analogique 2|cours") return coursAopComplet;
  return coursEtudiant[cle];
}

const Set<String> _filieresST = {
  "RIT", "EII", "GEENR", "ELT", "MIGMP",
  "MBH", "AB", "AGRO", "GC", "GM"
};

const Map<String, List<String>> _modulesCommunsST = {
  "L2": ["Electronique Analogique 2"],
};

List<String> ajouterModulesCommuns(
    String codeFiliere,
    String niveau,
    List<String> base,
    ) {
  if (!_filieresST.contains(codeFiliere)) return base;
  final extra = _modulesCommunsST[niveau] ?? const <String>[];
  return [...base, ...extra.where((m) => !base.contains(m))];
}

