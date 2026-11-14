import "package:flutter/material.dart";

enum NiveauDiplome { bepc, bac, licence }

extension NiveauDiplomeExt on NiveauDiplome {
  String get label {
    switch (this) {
      case NiveauDiplome.bepc: return "BEPC";
      case NiveauDiplome.bac: return "BAC";
      case NiveauDiplome.licence: return "LICENCE";
    }
  }

  Color get color {
    switch (this) {
      case NiveauDiplome.bepc: return const Color(0xFF1E88E5);
      case NiveauDiplome.bac: return const Color(0xFFFFB300);
      case NiveauDiplome.licence: return const Color(0xFF8E24AA);
    }
  }

  IconData get icon {
    switch (this) {
      case NiveauDiplome.bepc: return Icons.menu_book_outlined;
      case NiveauDiplome.bac: return Icons.workspace_premium_outlined;
      case NiveauDiplome.licence: return Icons.account_balance_outlined;
    }
  }
}

class ConcoursModel {
  final String nom, description, dateComposition, dateInscription;
  final NiveauDiplome niveau;
  final IconData icon;
  final Color color;

  const ConcoursModel({
    required this.nom, required this.description, required this.niveau,
    required this.icon, required this.color, required this.dateComposition,
    required this.dateInscription,
  });
}

class MatiereModel {
  final String id, nom;
  final IconData icon;
  final Color color;
  final int totalQuestions;

  const MatiereModel({
    required this.id, required this.nom, required this.icon,
    required this.color, required this.totalQuestions,
  });
}

class QuestionQCM {
  final String question, explication;
  final List<String> options;
  final int bonneReponse;

  const QuestionQCM({
    required this.question, required this.options,
    required this.bonneReponse, required this.explication,
  });
}

class ConcoursData {
  static const List<ConcoursModel> tous = [
    ConcoursModel(nom: "Assistant de Securite Penitentiaire", description: "Surveillance et securite des etablissements penitentiaires", niveau: NiveauDiplome.bepc, icon: Icons.lock_outlined, color: Color(0xFF1565C0), dateComposition: "15 Juin 2026", dateInscription: "01 Mai 2026"),
    ConcoursModel(nom: "Assistant des Douanes", description: "Controle aux frontieres et lutte contre la fraude", niveau: NiveauDiplome.bepc, icon: Icons.security_outlined, color: Color(0xFF00897B), dateComposition: "18 Juin 2026", dateInscription: "03 Mai 2026"),
    ConcoursModel(nom: "Assistant des Eaux et Forets", description: "Protection des ressources naturelles et forestieres", niveau: NiveauDiplome.bepc, icon: Icons.forest_outlined, color: Color(0xFF388E3C), dateComposition: "20 Juin 2026", dateInscription: "05 Mai 2026"),
    ConcoursModel(nom: "Agent Technique Geometre", description: "Topographie, cadastre et mesures foncieres", niveau: NiveauDiplome.bepc, icon: Icons.straighten_outlined, color: Color(0xFF6D4C41), dateComposition: "22 Juin 2026", dateInscription: "07 Mai 2026"),
    ConcoursModel(nom: "Agent Technique de l Environnement", description: "Surveillance et protection de l environnement", niveau: NiveauDiplome.bepc, icon: Icons.eco_outlined, color: Color(0xFF2E7D32), dateComposition: "24 Juin 2026", dateInscription: "09 Mai 2026"),
    ConcoursModel(nom: "Agent Technique en Transport", description: "Regulation et gestion des transports", niveau: NiveauDiplome.bepc, icon: Icons.directions_bus_outlined, color: Color(0xFFE65100), dateComposition: "25 Juin 2026", dateInscription: "10 Mai 2026"),
    ConcoursModel(nom: "Adjoint Administratif", description: "Administration generale et services publics", niveau: NiveauDiplome.bepc, icon: Icons.admin_panel_settings_outlined, color: Color(0xFF1E88E5), dateComposition: "27 Juin 2026", dateInscription: "12 Mai 2026"),
    ConcoursModel(nom: "ENAREF Cycle C", description: "Ecole Nationale des Regies Financieres - Cycle C", niveau: NiveauDiplome.bepc, icon: Icons.account_balance_outlined, color: Color(0xFF5E35B1), dateComposition: "28 Juin 2026", dateInscription: "13 Mai 2026"),
    ConcoursModel(nom: "Agent Technique en Agriculture", description: "Appui aux producteurs agricoles et ruraux", niveau: NiveauDiplome.bepc, icon: Icons.agriculture_outlined, color: Color(0xFF558B2F), dateComposition: "30 Juin 2026", dateInscription: "15 Mai 2026"),
    ConcoursModel(nom: "Adjoint en Education Sociale", description: "Accompagnement social et educatif des populations", niveau: NiveauDiplome.bepc, icon: Icons.people_outlined, color: Color(0xFFAD1457), dateComposition: "01 Juillet 2026", dateInscription: "16 Mai 2026"),
    ConcoursModel(nom: "Agent Technique en Genie Civil", description: "Construction et infrastructure publique", niveau: NiveauDiplome.bepc, icon: Icons.construction_outlined, color: Color(0xFF795548), dateComposition: "02 Juillet 2026", dateInscription: "17 Mai 2026"),
    ConcoursModel(nom: "Agent Technique d Elevage et de Sante Animale", description: "Suivi sanitaire du betail et appui aux eleveurs", niveau: NiveauDiplome.bepc, icon: Icons.pets_outlined, color: Color(0xFF00695C), dateComposition: "03 Juillet 2026", dateInscription: "18 Mai 2026"),
    ConcoursModel(nom: "Technicien Hygiene Hospitaliere", description: "Hygiene et salubrite en milieu de soins", niveau: NiveauDiplome.bepc, icon: Icons.local_hospital_outlined, color: Color(0xFF0277BD), dateComposition: "04 Juillet 2026", dateInscription: "19 Mai 2026"),
    ConcoursModel(nom: "Agent de Sante Communautaire", description: "Soins de sante primaires au niveau communautaire", niveau: NiveauDiplome.bepc, icon: Icons.health_and_safety_outlined, color: Color(0xFF00838F), dateComposition: "05 Juillet 2026", dateInscription: "20 Mai 2026"),
    ConcoursModel(nom: "Adjoint en Gestion des RH et Management", description: "Gestion des ressources humaines et administration", niveau: NiveauDiplome.bepc, icon: Icons.manage_accounts_outlined, color: Color(0xFF37474F), dateComposition: "07 Juillet 2026", dateInscription: "22 Mai 2026"),
    ConcoursModel(nom: "Adjoint en Documentation", description: "Gestion et organisation des documents administratifs", niveau: NiveauDiplome.bepc, icon: Icons.folder_outlined, color: Color(0xFF4527A0), dateComposition: "08 Juillet 2026", dateInscription: "23 Mai 2026"),
    ConcoursModel(nom: "Adjoint en Bibliotheconomie", description: "Gestion des fonds documentaires et bibliotheques", niveau: NiveauDiplome.bepc, icon: Icons.local_library_outlined, color: Color(0xFF283593), dateComposition: "09 Juillet 2026", dateInscription: "24 Mai 2026"),
    ConcoursModel(nom: "Adjoint en Archivistique", description: "Conservation et gestion des archives publiques", niveau: NiveauDiplome.bepc, icon: Icons.archive_outlined, color: Color(0xFF4E342E), dateComposition: "10 Juillet 2026", dateInscription: "25 Mai 2026"),
    ConcoursModel(nom: "Adjoint de Secretariat", description: "Secretariat administratif et accueil institutionnel", niveau: NiveauDiplome.bepc, icon: Icons.edit_note_outlined, color: Color(0xFF00796B), dateComposition: "11 Juillet 2026", dateInscription: "26 Mai 2026"),

    // BAC
    ConcoursModel(nom: "Eleves Sous-Officiers de la Police", description: "Formation des sous-officiers de la police nationale", niveau: NiveauDiplome.bac, icon: Icons.local_police_outlined, color: Color(0xFF1565C0), dateComposition: "15 Juin 2026", dateInscription: "01 Mai 2026"),
    ConcoursModel(nom: "ENSOA", description: "Ecole Nationale des Sous-Officiers d Active", niveau: NiveauDiplome.bac, icon: Icons.military_tech_outlined, color: Color(0xFF37474F), dateComposition: "17 Juin 2026", dateInscription: "03 Mai 2026"),
    ConcoursModel(nom: "Eleves Sous-Officiers de la Gendarmerie", description: "Formation des sous-officiers de gendarmerie", niveau: NiveauDiplome.bac, icon: Icons.shield_outlined, color: Color(0xFF283593), dateComposition: "18 Juin 2026", dateInscription: "04 Mai 2026"),
    ConcoursModel(nom: "Controleurs des Douanes", description: "Controle douanier et lutte contre la contrebande", niveau: NiveauDiplome.bac, icon: Icons.security_outlined, color: Color(0xFF00695C), dateComposition: "20 Juin 2026", dateInscription: "06 Mai 2026"),
    ConcoursModel(nom: "ENAREF Cycle B", description: "Ecole Nationale des Regies Financieres - Cycle B", niveau: NiveauDiplome.bac, icon: Icons.account_balance_outlined, color: Color(0xFF6A1B9A), dateComposition: "22 Juin 2026", dateInscription: "08 Mai 2026"),
    ConcoursModel(nom: "Educateur de la Petite Enfance", description: "Prise en charge educative des enfants de 0 a 6 ans", niveau: NiveauDiplome.bac, icon: Icons.child_care_outlined, color: Color(0xFFE91E63), dateComposition: "23 Juin 2026", dateInscription: "09 Mai 2026"),
    ConcoursModel(nom: "Attache d Intendance Scolaire et Universitaire", description: "Gestion administrative et financiere des etablissements", niveau: NiveauDiplome.bac, icon: Icons.school_outlined, color: Color(0xFFFF6F00), dateComposition: "24 Juin 2026", dateInscription: "10 Mai 2026"),
    ConcoursModel(nom: "Infirmier", description: "Soins infirmiers et accompagnement des patients", niveau: NiveauDiplome.bac, icon: Icons.medical_services_outlined, color: Color(0xFF0277BD), dateComposition: "25 Juin 2026", dateInscription: "11 Mai 2026"),
    ConcoursModel(nom: "Gestionnaire des Services de Sante", description: "Administration et gestion des structures sanitaires", niveau: NiveauDiplome.bac, icon: Icons.local_hospital_outlined, color: Color(0xFF00838F), dateComposition: "26 Juin 2026", dateInscription: "12 Mai 2026"),
    ConcoursModel(nom: "Assistant en Education Specialisee", description: "Accompagnement des personnes en situation de handicap", niveau: NiveauDiplome.bac, icon: Icons.accessibility_new_outlined, color: Color(0xFF558B2F), dateComposition: "27 Juin 2026", dateInscription: "13 Mai 2026"),
    ConcoursModel(nom: "Assistant en Education Sociale", description: "Intervention sociale et accompagnement des familles", niveau: NiveauDiplome.bac, icon: Icons.people_outlined, color: Color(0xFFAD1457), dateComposition: "28 Juin 2026", dateInscription: "14 Mai 2026"),
    ConcoursModel(nom: "Sage-Femme / Maieuticien", description: "Suivi des grossesses et accouchements", niveau: NiveauDiplome.bac, icon: Icons.pregnant_woman_outlined, color: Color(0xFFC2185B), dateComposition: "29 Juin 2026", dateInscription: "15 Mai 2026"),
    ConcoursModel(nom: "Assistant en Promotion du Genre", description: "Promotion de l egalite et des droits des femmes", niveau: NiveauDiplome.bac, icon: Icons.diversity_3_outlined, color: Color(0xFF7B1FA2), dateComposition: "30 Juin 2026", dateInscription: "16 Mai 2026"),
    ConcoursModel(nom: "Secretaire Administratif", description: "Secretariat, redaction et gestion administrative", niveau: NiveauDiplome.bac, icon: Icons.edit_note_outlined, color: Color(0xFF1976D2), dateComposition: "01 Juillet 2026", dateInscription: "17 Mai 2026"),
    ConcoursModel(nom: "Professeur des Ecoles", description: "Enseignement primaire et pedagogie", niveau: NiveauDiplome.bac, icon: Icons.class_outlined, color: Color(0xFF388E3C), dateComposition: "02 Juillet 2026", dateInscription: "18 Mai 2026"),
    ConcoursModel(nom: "Assistant en Gestion des RH et Management", description: "Ressources humaines et management des administrations", niveau: NiveauDiplome.bac, icon: Icons.manage_accounts_outlined, color: Color(0xFF455A64), dateComposition: "03 Juillet 2026", dateInscription: "19 Mai 2026"),
    ConcoursModel(nom: "Assistant en Documentation", description: "Organisation et traitement de l information documentaire", niveau: NiveauDiplome.bac, icon: Icons.folder_outlined, color: Color(0xFF4527A0), dateComposition: "04 Juillet 2026", dateInscription: "20 Mai 2026"),
    ConcoursModel(nom: "Assistant en Bibliotheconomie", description: "Gestion des collections bibliographiques", niveau: NiveauDiplome.bac, icon: Icons.local_library_outlined, color: Color(0xFF283593), dateComposition: "05 Juillet 2026", dateInscription: "21 Mai 2026"),
    ConcoursModel(nom: "Assistant en Archivistique", description: "Gestion et conservation des archives", niveau: NiveauDiplome.bac, icon: Icons.archive_outlined, color: Color(0xFF4E342E), dateComposition: "06 Juillet 2026", dateInscription: "22 Mai 2026"),
    ConcoursModel(nom: "Controleur du Travail", description: "Inspection du travail et droit du travail", niveau: NiveauDiplome.bac, icon: Icons.gavel_outlined, color: Color(0xFFE65100), dateComposition: "07 Juillet 2026", dateInscription: "23 Mai 2026"),
    ConcoursModel(nom: "Assistant en Droits Humains", description: "Promotion et defense des droits de l homme", niveau: NiveauDiplome.bac, icon: Icons.balance_outlined, color: Color(0xFF880E4F), dateComposition: "08 Juillet 2026", dateInscription: "24 Mai 2026"),
    ConcoursModel(nom: "Assistant en Interpretation Judiciaire", description: "Traduction et interpretation en milieu judiciaire", niveau: NiveauDiplome.bac, icon: Icons.record_voice_over_outlined, color: Color(0xFF00695C), dateComposition: "09 Juillet 2026", dateInscription: "25 Mai 2026"),
    ConcoursModel(nom: "Assistant en Emploi et Formation Professionnelle", description: "Insertion professionnelle et formation continue", niveau: NiveauDiplome.bac, icon: Icons.work_outline, color: Color(0xFF1B5E20), dateComposition: "10 Juillet 2026", dateInscription: "26 Mai 2026"),
    ConcoursModel(nom: "Inspecteur Specialise de Jeunesse et d Education Permanente", description: "Animation et encadrement de la jeunesse", niveau: NiveauDiplome.bac, icon: Icons.groups_outlined, color: Color(0xFF0D47A1), dateComposition: "11 Juillet 2026", dateInscription: "27 Mai 2026"),
    ConcoursModel(nom: "Maitre des Activites Physiques et Sportives", description: "Enseignement et encadrement du sport", niveau: NiveauDiplome.bac, icon: Icons.sports_outlined, color: Color(0xFFBF360C), dateComposition: "12 Juillet 2026", dateInscription: "28 Mai 2026"),
    ConcoursModel(nom: "Technicien Superieur en Hydraulique", description: "Gestion des ressources en eau", niveau: NiveauDiplome.bac, icon: Icons.water_outlined, color: Color(0xFF0277BD), dateComposition: "13 Juillet 2026", dateInscription: "29 Mai 2026"),
    ConcoursModel(nom: "Controleur des Eaux et Forets", description: "Controle forestier et gestion des ressources naturelles", niveau: NiveauDiplome.bac, icon: Icons.forest_outlined, color: Color(0xFF33691E), dateComposition: "14 Juillet 2026", dateInscription: "30 Mai 2026"),
    ConcoursModel(nom: "Technicien Superieur de l Environnement", description: "Gestion et preservation de l environnement", niveau: NiveauDiplome.bac, icon: Icons.eco_outlined, color: Color(0xFF2E7D32), dateComposition: "15 Juillet 2026", dateInscription: "31 Mai 2026"),
    ConcoursModel(nom: "Technicien Superieur Geometre", description: "Topographie et releves fonciers avances", niveau: NiveauDiplome.bac, icon: Icons.map_outlined, color: Color(0xFF6D4C41), dateComposition: "16 Juillet 2026", dateInscription: "01 Juin 2026"),
    ConcoursModel(nom: "Technicien Superieur en Architecture", description: "Conception et dessin architectural", niveau: NiveauDiplome.bac, icon: Icons.architecture_outlined, color: Color(0xFF4E342E), dateComposition: "17 Juillet 2026", dateInscription: "02 Juin 2026"),
    ConcoursModel(nom: "Technicien Superieur Urbaniste", description: "Planification et amenagement urbain", niveau: NiveauDiplome.bac, icon: Icons.location_city_outlined, color: Color(0xFF37474F), dateComposition: "18 Juillet 2026", dateInscription: "03 Juin 2026"),
    ConcoursModel(nom: "Technicien Superieur en Agriculture", description: "Developpement agricole et agropastoral", niveau: NiveauDiplome.bac, icon: Icons.agriculture_outlined, color: Color(0xFF558B2F), dateComposition: "19 Juillet 2026", dateInscription: "04 Juin 2026"),
    ConcoursModel(nom: "Technicien Superieur en Genie Civil", description: "Travaux publics et infrastructures", niveau: NiveauDiplome.bac, icon: Icons.construction_outlined, color: Color(0xFF795548), dateComposition: "20 Juillet 2026", dateInscription: "05 Juin 2026"),
    ConcoursModel(nom: "Technicien Superieur d Elevage et de Sante Animale", description: "Sante animale et production animale", niveau: NiveauDiplome.bac, icon: Icons.pets_outlined, color: Color(0xFF00695C), dateComposition: "21 Juillet 2026", dateInscription: "06 Juin 2026"),
    ConcoursModel(nom: "Technicien Biomedical", description: "Maintenance des equipements medicaux", niveau: NiveauDiplome.bac, icon: Icons.biotech_outlined, color: Color(0xFF1565C0), dateComposition: "22 Juillet 2026", dateInscription: "07 Juin 2026"),
    ConcoursModel(nom: "Technicien Superieur en Imagerie Medicale", description: "Radiologie et techniques d imagerie", niveau: NiveauDiplome.bac, icon: Icons.medical_information_outlined, color: Color(0xFF01579B), dateComposition: "23 Juillet 2026", dateInscription: "08 Juin 2026"),
    ConcoursModel(nom: "Technicien Superieur du Genie Sanitaire", description: "Assainissement et sante environnementale", niveau: NiveauDiplome.bac, icon: Icons.health_and_safety_outlined, color: Color(0xFF00838F), dateComposition: "24 Juillet 2026", dateInscription: "09 Juin 2026"),
    ConcoursModel(nom: "Preparation d Etat en Pharmacie", description: "Sciences pharmaceutiques et gestion des medicaments", niveau: NiveauDiplome.bac, icon: Icons.medication_outlined, color: Color(0xFF6A1B9A), dateComposition: "25 Juillet 2026", dateInscription: "10 Juin 2026"),
    ConcoursModel(nom: "CAPES-CEG (Enseignement General)", description: "Professeurs certifies des colleges - disciplines generales", niveau: NiveauDiplome.bac, icon: Icons.menu_book_outlined, color: Color(0xFF1A237E), dateComposition: "26 Juillet 2026", dateInscription: "11 Juin 2026"),
    ConcoursModel(nom: "CAPES-CEG option EPS", description: "Professeurs certifies des colleges - Education Physique", niveau: NiveauDiplome.bac, icon: Icons.sports_soccer_outlined, color: Color(0xFFBF360C), dateComposition: "27 Juillet 2026", dateInscription: "12 Juin 2026"),
    ConcoursModel(nom: "Concours Niveau Baccalaureat Scientifique", description: "Concours ouvert aux titulaires de BAC scientifique", niveau: NiveauDiplome.bac, icon: Icons.science_outlined, color: Color(0xFF004D40), dateComposition: "28 Juillet 2026", dateInscription: "13 Juin 2026"),
    ConcoursModel(nom: "Concours Tous Baccalaureats", description: "Concours ouvert a tous les titulaires du BAC", niveau: NiveauDiplome.bac, icon: Icons.workspace_premium_outlined, color: Color(0xFFE65100), dateComposition: "29 Juillet 2026", dateInscription: "14 Juin 2026"),

    // LICENCE
    ConcoursModel(nom: "Attache des Impots", description: "Fiscalite, controle et administration des impots", niveau: NiveauDiplome.licence, icon: Icons.receipt_long_outlined, color: Color(0xFF1565C0), dateComposition: "15 Aout 2026", dateInscription: "01 Juillet 2026"),
    ConcoursModel(nom: "Attache des Douanes", description: "Administration et controle douanier de haut niveau", niveau: NiveauDiplome.licence, icon: Icons.security_outlined, color: Color(0xFF00695C), dateComposition: "17 Aout 2026", dateInscription: "03 Juillet 2026"),
    ConcoursModel(nom: "ENAREF Cycle A", description: "Ecole Nationale des Regies Financieres - Cycle A", niveau: NiveauDiplome.licence, icon: Icons.account_balance_outlined, color: Color(0xFF6A1B9A), dateComposition: "18 Aout 2026", dateInscription: "04 Juillet 2026"),
    ConcoursModel(nom: "Inspecteur du Travail et des Lois Sociales", description: "Controle de l application du droit du travail", niveau: NiveauDiplome.licence, icon: Icons.gavel_outlined, color: Color(0xFFE65100), dateComposition: "20 Aout 2026", dateInscription: "06 Juillet 2026"),
    ConcoursModel(nom: "Magistrat", description: "Formation a la magistrature judiciaire", niveau: NiveauDiplome.licence, icon: Icons.balance_outlined, color: Color(0xFF37474F), dateComposition: "22 Aout 2026", dateInscription: "08 Juillet 2026"),
    ConcoursModel(nom: "Administrateur Civil", description: "Haute administration territoriale et centrale", niveau: NiveauDiplome.licence, icon: Icons.account_balance_outlined, color: Color(0xFF1A237E), dateComposition: "24 Aout 2026", dateInscription: "10 Juillet 2026"),
    ConcoursModel(nom: "Diplomate", description: "Carriere diplomatique et relations internationales", niveau: NiveauDiplome.licence, icon: Icons.public_outlined, color: Color(0xFF0D47A1), dateComposition: "26 Aout 2026", dateInscription: "12 Juillet 2026"),
    ConcoursModel(nom: "Officier de Police", description: "Encadrement et commandement de la police nationale", niveau: NiveauDiplome.licence, icon: Icons.local_police_outlined, color: Color(0xFF1565C0), dateComposition: "28 Aout 2026", dateInscription: "14 Juillet 2026"),
    ConcoursModel(nom: "Officier de Gendarmerie (EOGN)", description: "Ecole des Officiers de la Gendarmerie Nationale", niveau: NiveauDiplome.licence, icon: Icons.shield_outlined, color: Color(0xFF283593), dateComposition: "30 Aout 2026", dateInscription: "16 Juillet 2026"),
    ConcoursModel(nom: "Ingenieur des Travaux Statistiques", description: "Production et analyse des donnees statistiques nationales", niveau: NiveauDiplome.licence, icon: Icons.bar_chart_outlined, color: Color(0xFF00838F), dateComposition: "01 Septembre 2026", dateInscription: "18 Juillet 2026"),
    ConcoursModel(nom: "Attache en Gestion des RH et Management", description: "Gestion strategique des ressources humaines publiques", niveau: NiveauDiplome.licence, icon: Icons.manage_accounts_outlined, color: Color(0xFF455A64), dateComposition: "03 Septembre 2026", dateInscription: "20 Juillet 2026"),
    ConcoursModel(nom: "Attache en Documentation", description: "Gestion avancee de l information documentaire", niveau: NiveauDiplome.licence, icon: Icons.folder_outlined, color: Color(0xFF4527A0), dateComposition: "05 Septembre 2026", dateInscription: "22 Juillet 2026"),
    ConcoursModel(nom: "Conservateur de Bibliotheque", description: "Direction et conservation des grandes bibliotheques", niveau: NiveauDiplome.licence, icon: Icons.local_library_outlined, color: Color(0xFF283593), dateComposition: "07 Septembre 2026", dateInscription: "24 Juillet 2026"),
    ConcoursModel(nom: "Conservateur d Archives", description: "Direction des services d archives nationales", niveau: NiveauDiplome.licence, icon: Icons.archive_outlined, color: Color(0xFF4E342E), dateComposition: "09 Septembre 2026", dateInscription: "26 Juillet 2026"),
  ];

  static List<ConcoursModel> parNiveau(NiveauDiplome niveau) =>
      tous.where((c) => c.niveau == niveau).toList();

  // ============ MATIERES ============
  static const List<MatiereModel> matieres = [
    MatiereModel(id: "actualite", nom: "Actualite", icon: Icons.newspaper_outlined, color: Color(0xFF1565C0), totalQuestions: 10),
    MatiereModel(id: "culture_generale", nom: "Culture Generale", icon: Icons.public_outlined, color: Color(0xFF00838F), totalQuestions: 10),
    MatiereModel(id: "francais", nom: "Francais", icon: Icons.menu_book_outlined, color: Color(0xFF2E7D32), totalQuestions: 10),
    MatiereModel(id: "histoire_geo", nom: "Histoire-Geographie", icon: Icons.map_outlined, color: Color(0xFFE65100), totalQuestions: 10),
    MatiereModel(id: "maths", nom: "Mathematiques", icon: Icons.calculate_outlined, color: Color(0xFF1A237E), totalQuestions: 10),
    MatiereModel(id: "svt", nom: "SVT", icon: Icons.eco_outlined, color: Color(0xFF388E3C), totalQuestions: 10),
    MatiereModel(id: "psychotechnique", nom: "Psychotechnique", icon: Icons.psychology_outlined, color: Color(0xFF6A1B9A), totalQuestions: 10),
    MatiereModel(id: "accompagnement", nom: "Accompagnement", icon: Icons.support_agent_outlined, color: Color(0xFF00695C), totalQuestions: 5),
  ];

  // ============ QUESTIONS QCM (exemples par matiere) ============
  static const Map<String, List<QuestionQCM>> questionsParMatiere = {
    "culture_generale": [
      QuestionQCM(
        question: "Quelle est la capitale du Burkina Faso ?",
        options: ["Bobo-Dioulasso", "Ouagadougou", "Koudougou", "Banfora"],
        bonneReponse: 1,
        explication: "Ouagadougou est la capitale politique et administrative du Burkina Faso depuis l independance en 1960.",
      ),
      QuestionQCM(
        question: "En quelle annee le Burkina Faso a-t-il obtenu son independance ?",
        options: ["1958", "1960", "1962", "1965"],
        bonneReponse: 1,
        explication: "Le Burkina Faso (alors Haute-Volta) a obtenu son independance le 5 aout 1960.",
      ),
      QuestionQCM(
        question: "Quel est l ancien nom du Burkina Faso ?",
        options: ["Haute-Volta", "Soudan francais", "Cote d Ivoire", "Mali"],
        bonneReponse: 0,
        explication: "Le pays s appelait Haute-Volta avant d etre renomme Burkina Faso en 1984 sous Thomas Sankara.",
      ),
      QuestionQCM(
        question: "Qui est considere comme le pere de la revolution burkinabe ?",
        options: ["Blaise Compaore", "Thomas Sankara", "Maurice Yameogo", "Roch Kabore"],
        bonneReponse: 1,
        explication: "Thomas Sankara a dirige la revolution burkinabe de 1983 a 1987 et a renomme le pays Burkina Faso.",
      ),
      QuestionQCM(
        question: "Combien de regions administratives compte le Burkina Faso ?",
        options: ["10", "13", "16", "20"],
        bonneReponse: 2,
        explication: "Le Burkina Faso compte 13 regions administratives.",
      ),
    ],
    "francais": [
      QuestionQCM(
        question: "Quel est le synonyme de perspicace ?",
        options: ["Naif", "Astucieux", "Distrait", "Lent"],
        bonneReponse: 1,
        explication: "Perspicace signifie astucieux, qui comprend vite et avec finesse.",
      ),
      QuestionQCM(
        question: "Conjuguez le verbe finir au present de l indicatif, 3e personne du pluriel :",
        options: ["Ils finissent", "Ils finiront", "Ils finissaient", "Ils finirent"],
        bonneReponse: 0,
        explication: "Au present de l indicatif, la 3e personne du pluriel du verbe finir est ils finissent.",
      ),
      QuestionQCM(
        question: "Quel est l antonyme de genereux ?",
        options: ["Avare", "Riche", "Sympathique", "Aimable"],
        bonneReponse: 0,
        explication: "Avare est le contraire de genereux.",
      ),
    ],
    "maths": [
      QuestionQCM(
        question: "Quel est le resultat de 15 x 8 ?",
        options: ["110", "120", "130", "115"],
        bonneReponse: 1,
        explication: "15 x 8 = 120.",
      ),
      QuestionQCM(
        question: "Si x + 5 = 12, quelle est la valeur de x ?",
        options: ["5", "6", "7", "8"],
        bonneReponse: 2,
        explication: "x + 5 = 12 donc x = 12 - 5 = 7.",
      ),
      QuestionQCM(
        question: "Quel est le perimetre d un carre de cote 6 cm ?",
        options: ["12 cm", "18 cm", "24 cm", "36 cm"],
        bonneReponse: 2,
        explication: "Le perimetre d un carre = 4 x cote = 4 x 6 = 24 cm.",
      ),
    ],
    "histoire_geo": [
      QuestionQCM(
        question: "Quel fleuve traverse le Burkina Faso ?",
        options: ["Le Nil", "Le Niger", "Le Congo", "Le Senegal"],
        bonneReponse: 1,
        explication: "Le fleuve Niger traverse une partie du territoire burkinabe.",
      ),
      QuestionQCM(
        question: "Quelle est la langue officielle du Burkina Faso ?",
        options: ["L anglais", "Le francais", "L arabe", "Le portugais"],
        bonneReponse: 1,
        explication: "Le francais est la langue officielle du Burkina Faso, heritee de la colonisation.",
      ),
    ],
    "svt": [
      QuestionQCM(
        question: "Quel organe pompe le sang dans le corps humain ?",
        options: ["Le foie", "Le coeur", "Les poumons", "Les reins"],
        bonneReponse: 1,
        explication: "Le coeur est l organe qui pompe le sang dans tout le corps.",
      ),
      QuestionQCM(
        question: "Quel gaz les plantes absorbent-elles pour la photosynthese ?",
        options: ["Oxygene", "Azote", "Dioxyde de carbone", "Hydrogene"],
        bonneReponse: 2,
        explication: "Les plantes absorbent le dioxyde de carbone (CO2) pour realiser la photosynthese.",
      ),
    ],
    "psychotechnique": [
      QuestionQCM(
        question: "Quel nombre complete la suite : 2, 4, 8, 16, ... ?",
        options: ["24", "32", "20", "18"],
        bonneReponse: 1,
        explication: "La suite double a chaque fois : 2, 4, 8, 16, 32.",
      ),
      QuestionQCM(
        question: "Trouvez l intrus : Chat, Chien, Table, Lion",
        options: ["Chat", "Chien", "Table", "Lion"],
        bonneReponse: 2,
        explication: "Table est l intrus car ce n est pas un animal, contrairement aux trois autres.",
      ),

    ],
    "actualite": [
      QuestionQCM(
        question: "Quel organisme regional regroupe plusieurs pays d Afrique de l Ouest ?",
        options: ["UE", "CEDEAO", "ONU", "OTAN"],
        bonneReponse: 1,
        explication: "La CEDEAO (Communaute Economique des Etats de l Afrique de l Ouest) regroupe les pays ouest-africains.",
      ),
    ],
    "accompagnement": [
      QuestionQCM(
        question: "Quelle qualite est essentielle pour un agent de la fonction publique ?",
        options: ["L integrite", "L indifference", "La lenteur", "L improvisation"],
        bonneReponse: 0,
        explication: "L integrite est une valeur fondamentale attendue dans la fonction publique.",
      ),
    ],
  };
}
