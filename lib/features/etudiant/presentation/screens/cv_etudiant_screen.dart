import "../../../../core/services/cv_pdf_service.dart";
import "../../../../core/services/profil_service.dart";
import "package:flutter/material.dart";

class CvEtudiantScreen extends StatefulWidget {
  const CvEtudiantScreen({super.key});

  @override
  State<CvEtudiantScreen> createState() => _CvEtudiantScreenState();
}

class _CvEtudiantScreenState extends State<CvEtudiantScreen> {
  int _selectedTab = 0;

  String nom = "";
  String titre = "";
  String telephone = "";
  String email = "";
  String adresse = "";
  String profil = "";
  List<Map<String, String>> formations = [];
  List<Map<String, String>> experiences = [];
  List<String> competences = [];
  List<Map<String, String>> langues = [];
  List<String> centresInteret = [];

  bool cvCree = false;

  @override
  void initState() {
    super.initState();
    _chargerCv();
  }

  Future<void> _chargerCv() async {
    try {
      final d = await ProfilService.chargerCv("cv_etudiant");
      if (d == null || !mounted) return;
      setState(() {
        nom = d["nom"] ?? "";
        titre = d["titre"] ?? "";
        telephone = d["telephone"] ?? "";
        email = d["email"] ?? "";
        adresse = d["adresse"] ?? "";
        profil = d["profil"] ?? "";
        formations = ProfilService.listeMaps(d["formations"]);
        experiences = ProfilService.listeMaps(d["experiences"]);
        competences = ProfilService.listeTextes(d["competences"]);
        langues = ProfilService.listeMaps(d["langues"]);
        centresInteret = ProfilService.listeTextes(d["centres_interet"]);
        cvCree = true;
      });
    } catch (e) {
      debugPrint("Chargement CV impossible : $e");
    }
  }

  Future<void> _sauvegarderCv(Map<String, dynamic> data) async {
    try {
      await ProfilService.sauvegarderCv("cv_etudiant", {
        "nom": data["nom"],
        "titre": data["titre"],
        "telephone": data["telephone"],
        "email": data["email"],
        "adresse": data["adresse"],
        "profil": data["profil"],
        "formations": data["formations"],
        "experiences": data["experiences"],
        "competences": data["competences"],
        "langues": data["langues"],
        "centres_interet": data["centresInteret"],
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CV enregistre"), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("CV non enregistre : $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B2D8E),
        title: const Text("Mon CV", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: cvCree ? [
          IconButton(icon: const Icon(Icons.picture_as_pdf, color: Colors.white), onPressed: _telechargerPDF),
        ] : null,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF5B2D8E),
            child: Row(
              children: [
                _buildTab(0, Icons.person_outlined, "Mon CV"),
                _buildTab(1, Icons.lightbulb_outlined, "Conseils"),
                _buildTab(2, Icons.star_border, "Modele"),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildMonCVTab(),
                _buildConseilsTab(),
                _buildModeleTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _ouvrirCreerCV(context);
        },
        backgroundColor: const Color(0xFF5B2D8E),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(cvCree ? "Modifier mon CV" : "Creer mon CV", style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isSelected ? Colors.white : Colors.transparent, width: 3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 22),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonCVTab() {
    if (!cvCree) {
      return const Center(child: Text("Appuyez sur le bouton pour creer votre CV", style: TextStyle(color: Colors.grey)));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                CircleAvatar(radius: 32, backgroundColor: Colors.white24, child: const Icon(Icons.person, size: 36, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nom.isEmpty ? "Votre Nom" : nom, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(titre.isEmpty ? "Titre / Poste recherche" : titre, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      if (email.isNotEmpty) Row(children: [const Icon(Icons.email, color: Colors.white70, size: 14), const SizedBox(width: 4), Text(email, style: const TextStyle(color: Colors.white70, fontSize: 12))]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _telechargerPDF,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Telecharger mon CV en PDF"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2D8E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConseilsTab() {
    final bonsConseils = [
      "Photo professionnelle : fond neutre, tenue correcte, sourire naturel",
      "Maximum 1 page pour un CV etudiant de stage",
      "Commencer par un profil clair qui explique qui vous etes et ce que vous cherchez",
      "Mettre en avant vos formations et vos competences en rapport avec le stage",
      "Utiliser des verbes d action : Gerer, Analyser, Developper, Organiser",
      "Mentionner les logiciels maitrises (Word, Excel, SAGE, etc.)",
      "Inclure un email professionnel (pas un email fantaisiste)",
      "Verifier l orthographe et la grammaire avant d envoyer",
      "Adapter votre CV a chaque offre de stage",
      "Mentionner vos centres d interet : ils revelent votre personnalite",

    ];
    final erreursAEviter = [
      "Ne pas mettre de photo ou mettre une photo inappropriee (selfie, photo de fete)",
      "Faire un CV de plus de 2 pages quand vous etes etudiant",
      "Mentir sur vos competences ou experiences",
      "Utiliser une adresse email non professionnelle ( ex: manga2007@yahoo.fr)",
      "Laisser des fautes d orthographe - redhibitoire pour les recruteurs",
      "Mettre des informations personnelles inutiles (religion, ethnie, statut marital)",
      "Utiliser un design surcharge de couleurs et images",
      "Ne pas adapter le cv à l'offre de stage ciblée",
      "Oublier de mentionner vos compétences informatiques",
      "Ne pas mettre un numéro de téléphone actif ou accessible",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Conseils pour un bon CV de stage", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 12),
          ...bonsConseils.map((c) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
            child: Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 12), Expanded(child: Text(c, style: const TextStyle(fontSize: 13)))]),
          )),
          const SizedBox(height: 20),
          const Text("Erreurs a eviter absolument", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 12),
          ...erreursAEviter.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
            child: Row(children: [const Icon(Icons.cancel, color: Colors.red, size: 20), const SizedBox(width: 12), Expanded(child: Text(e, style: const TextStyle(fontSize: 13)))]),
          )),
        ],
      ),
    );
  }

  Widget _buildModeleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.info_outline, color: Colors.purple),
              SizedBox(width: 8),
              Expanded(child: Text("Voici un exemple de CV professionnel adapte pour un stage. Inspirez-vous de cette structure !", style: TextStyle(fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8)]),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 28, backgroundColor: Colors.white24, child: const Icon(Icons.person, size: 30, color: Colors.white)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Aminata SAWADOGO", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("Etudiante en Gestion - Recherche de stage", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("+226 70 00 00 00", style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text("aminata.sawadogo@email.com", style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text("Ouagadougou, Burkina Faso", style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _modeleSection("PROFIL", "Etudiante serieuse et motivee en 2eme annee de Licence en Gestion des Entreprises. Je recherche un stage de 3 mois pour mettre en pratique mes connaissances en comptabilite et gestion financiere au sein d une entreprise dynamique."),
                      _modeleSectionList("FORMATION", ["Universite de Ouagadougou - 2023 - En cours", "Lycee Municipal de Ouagadougou - Juin 2023"]),
                      _modeleSectionList("EXPERIENCES / STAGES", ["Cabinet Comptable FIDUCIA - Juillet 2023 (1 mois)\nSaisie comptable, classement des pieces comptables, assistance a la preparation des bilans."]),
                      _modeleChips("COMPETENCES", ["Comptabilite generale", "Microsoft Excel / Word", "Logiciel SAGE", "Communication", "Travail en equipe"]),
                      _modeleChipsGrey("LANGUES", ["Francais - Courant", "Anglais - Intermediaire", "Moore - Langue maternelle"]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeleSection(String titre, String contenu) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
          const Divider(color: Colors.blue),
          Text(contenu, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _modeleSectionList(String titre, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
          const Divider(color: Colors.blue),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("- ", style: TextStyle(color: Colors.blue, fontSize: 16)),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 13))),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _modeleChips(String titre, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
          const Divider(color: Colors.blue),
          Wrap(spacing: 8, runSpacing: 8, children: items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blue.shade200)),
            child: Text(item, style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
          )).toList()),
        ],
      ),
    );
  }

  Widget _modeleChipsGrey(String titre, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
          const Divider(color: Colors.blue),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
              child: Text(item, style: const TextStyle(fontSize: 13)),
            ),
          )),
        ],
      ),
    );
  }

  void _ouvrirCreerCV(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CreerCvScreen(
      nomInitial: nom,
      titreInitial: titre,
      telephoneInitial: telephone,
      emailInitial: email,
      adresseInitial: adresse,
      profilInitial: profil,
      formationsInitial: formations,
      experiencesInitial: experiences,
      competencesInitial: competences,
      languesInitial: langues,
      centresInteretInitial: centresInteret,
      onSave: (data) {
        _sauvegarderCv(data);
        setState(() {
          nom = data["nom"] ?? "";
          titre = data["titre"] ?? "";
          telephone = data["telephone"] ?? "";
          email = data["email"] ?? "";
          adresse = data["adresse"] ?? "";
          profil = data["profil"] ?? "";
          formations = List<Map<String, String>>.from(data["formations"] ?? []);
          experiences = List<Map<String, String>>.from(data["experiences"] ?? []);
          competences = List<String>.from(data["competences"] ?? []);
          langues = List<Map<String, String>>.from(data["langues"] ?? []);
          centresInteret = List<String>.from(data["centresInteret"] ?? []);
          cvCree = true;
          _selectedTab = 0;
        });
      },
    )));
  }

  Future<void> _telechargerPDF() async {
    try {
      await CvPdfService.etudiant(
        nom: nom,
        titre: titre,
        telephone: telephone,
        email: email,
        adresse: adresse,
        profil: profil,
        formations: formations,
        experiences: experiences,
        competences: competences,
        langues: langues,
        centresInteret: centresInteret,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF impossible : $e"), backgroundColor: Colors.red),
      );
    }
  }
}

class CreerCvScreen extends StatefulWidget {
  final String nomInitial;
  final String titreInitial;
  final String telephoneInitial;
  final String emailInitial;
  final String adresseInitial;
  final String profilInitial;
  final List<Map<String, String>> formationsInitial;
  final List<Map<String, String>> experiencesInitial;
  final List<String> competencesInitial;
  final List<Map<String, String>> languesInitial;
  final List<String> centresInteretInitial;
  final Function(Map<String, dynamic>) onSave;

  const CreerCvScreen({
    super.key,
    required this.nomInitial,
    required this.titreInitial,
    required this.telephoneInitial,
    required this.emailInitial,
    required this.adresseInitial,
    required this.profilInitial,
    required this.formationsInitial,
    required this.experiencesInitial,
    required this.competencesInitial,
    required this.languesInitial,
    required this.centresInteretInitial,
    required this.onSave,
  });

  @override
  State<CreerCvScreen> createState() => _CreerCvScreenState();
}

class _CreerCvScreenState extends State<CreerCvScreen> {
  late TextEditingController _nomCtrl;
  late TextEditingController _titreCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _adresseCtrl;
  late TextEditingController _profilCtrl;
  late TextEditingController _competenceCtrl;

  late List<Map<String, String>> formations;
  late List<Map<String, String>> experiences;
  late List<String> competences;
  late List<Map<String, String>> langues;
  late List<String> centresInteret;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.nomInitial);
    _titreCtrl = TextEditingController(text: widget.titreInitial);
    _telCtrl = TextEditingController(text: widget.telephoneInitial);
    _emailCtrl = TextEditingController(text: widget.emailInitial);
    _adresseCtrl = TextEditingController(text: widget.adresseInitial);
    _profilCtrl = TextEditingController(text: widget.profilInitial);
    _competenceCtrl = TextEditingController();
    formations = List.from(widget.formationsInitial);
    experiences = List.from(widget.experiencesInitial);
    competences = List.from(widget.competencesInitial);
    langues = List.from(widget.languesInitial);
    centresInteret = List.from(widget.centresInteretInitial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B2D8E),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text("Creer mon CV", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.save, color: Colors.white), onPressed: _sauvegarder)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(radius: 48, backgroundColor: Colors.purple.shade100, child: Icon(Icons.person, size: 48, color: Colors.purple.shade300)),
                  Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 16, backgroundColor: const Color(0xFF5B2D8E), child: const Icon(Icons.camera_alt, color: Colors.white, size: 16))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text("Appuyez pour changer la photo", style: TextStyle(fontSize: 12, color: Colors.grey))),
            const SizedBox(height: 24),
            _sectionTitle("Informations personnelles"),
            _buildField(_nomCtrl, "Nom complet *", Icons.person),
            _buildField(_titreCtrl, "Titre / Poste recherche *", Icons.work_outline),
            _buildField(_telCtrl, "Telephone *", Icons.phone),
            _buildField(_emailCtrl, "Email *", Icons.email),
            _buildField(_adresseCtrl, "Adresse", Icons.location_on),
            const SizedBox(height: 20),
            _sectionTitle("Profil / Presentation"),
            TextField(
              controller: _profilCtrl,
              maxLines: 4,
              decoration: _inputDecoration("Decrivez-vous en 3-4 phrases", null),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Formations"),
            ...formations.map((f) => _itemCard("${f["diplome"]} - ${f["etablissement"]} - ${f["periode"]}", () {
              setState(() => formations.remove(f));
            })),
            _addButton("Ajouter une formation", () => _ajouterFormation()),
            const SizedBox(height: 20),
            _sectionTitle("Experiences / Stages"),
            ...experiences.map((e) => _itemCard("${e["poste"]} - ${e["entreprise"]}", () {
              setState(() => experiences.remove(e));
            })),
            _addButton("Ajouter une experience", () => _ajouterExperience()),
            const SizedBox(height: 20),
            _sectionTitle("Competences"),
            Row(
              children: [
                Expanded(child: TextField(controller: _competenceCtrl, decoration: _inputDecoration("Ajouter une competence", null))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_competenceCtrl.text.isNotEmpty) {
                      setState(() { competences.add(_competenceCtrl.text); _competenceCtrl.clear(); });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2D8E)),
                  child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: competences.map((c) => Chip(
                label: Text(c),
                onDeleted: () => setState(() => competences.remove(c)),
                backgroundColor: Colors.purple.shade50,
              )).toList(),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Langues"),
            ...langues.map((l) => _itemCard("${l["langue"]} - ${l["niveau"]}", () {
              setState(() => langues.remove(l));
            })),
            _addButton("Ajouter une langue", () => _ajouterLangue()),
            const SizedBox(height: 20),
            _sectionTitle("Centres d interet"),
            ...centresInteret.map((c) => _itemCard(c, () {
              setState(() => centresInteret.remove(c));
            })),
            _addButton("Ajouter un centre d interet", () => _ajouterCentreInteret()),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sauvegarder,
                icon: const Icon(Icons.save),
                label: const Text("Sauvegarder mon CV"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B2D8E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String titre) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(titre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: _inputDecoration(hint, icon),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _itemCard(String text, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF5B2D8E).withValues(alpha: 0.3))),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: onDelete),
        ],
      ),
    );
  }

  Widget _addButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF5B2D8E)),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.add_circle_outline, color: Color(0xFF5B2D8E)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Color(0xFF5B2D8E), fontWeight: FontWeight.w600)),
        ])),
      ),
    );
  }

  void _ajouterFormation() {
    final diplomeCtrl = TextEditingController();
    final etablissementCtrl = TextEditingController();
    final periodeCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text("Formation", style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogField(diplomeCtrl, "Diplome / Niveau *"),
        const SizedBox(height: 12),
        _dialogField(etablissementCtrl, "Etablissement *"),
        const SizedBox(height: 12),
        _dialogField(periodeCtrl, "Periode (ex: 2022-2023)"),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler", style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          onPressed: () {
            if (diplomeCtrl.text.isNotEmpty && etablissementCtrl.text.isNotEmpty) {
              setState(() => formations.add({"diplome": diplomeCtrl.text, "etablissement": etablissementCtrl.text, "periode": periodeCtrl.text}));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2D8E)),
          child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  void _ajouterExperience() {
    final posteCtrl = TextEditingController();
    final entrepriseCtrl = TextEditingController();
    final periodeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text("Experience / Stage", style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogField(posteCtrl, "Poste / Mission *"),
        const SizedBox(height: 12),
        _dialogField(entrepriseCtrl, "Entreprise / Structure"),
        const SizedBox(height: 12),
        _dialogField(periodeCtrl, "Periode"),
        const SizedBox(height: 12),
        TextField(controller: descCtrl, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Description des taches", hintStyle: TextStyle(color: Colors.white54), filled: true, fillColor: Colors.black54)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler", style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          onPressed: () {
            if (posteCtrl.text.isNotEmpty) {
              setState(() => experiences.add({"poste": posteCtrl.text, "entreprise": entrepriseCtrl.text, "periode": periodeCtrl.text, "description": descCtrl.text}));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2D8E)),
          child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  void _ajouterLangue() {
    final langueCtrl = TextEditingController();
    String niveauSelectionne = "Intermediaire";
    final niveaux = ["Debutant", "Intermediaire", "Avance", "Courant", "Bilingue", "Langue maternelle"];
    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (context, setStateDialog) => AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text("Langue", style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogField(langueCtrl, "Langue *"),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: niveauSelectionne,
          dropdownColor: Colors.grey.shade800,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: "Niveau", labelStyle: TextStyle(color: Colors.amber), filled: true, fillColor: Colors.black54, border: OutlineInputBorder()),
          items: niveaux.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
          onChanged: (v) => setStateDialog(() => niveauSelectionne = v!),
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler", style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          onPressed: () {
            if (langueCtrl.text.isNotEmpty) {
              setState(() => langues.add({"langue": langueCtrl.text, "niveau": niveauSelectionne}));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2D8E)),
          child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
        ),
      ],
    )));
  }

  void _ajouterCentreInteret() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text("Ajouter un centre d interet", style: TextStyle(color: Colors.white)),
      content: _dialogField(ctrl, "Centre d interet"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler", style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          onPressed: () {
            if (ctrl.text.isNotEmpty) {
              setState(() => centresInteret.add(ctrl.text));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2D8E)),
          child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  TextField _dialogField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white54), filled: true, fillColor: Colors.black54, border: const OutlineInputBorder()),
    );
  }

  void _sauvegarder() {
    widget.onSave({
      "nom": _nomCtrl.text,
      "titre": _titreCtrl.text,
      "telephone": _telCtrl.text,
      "email": _emailCtrl.text,
      "adresse": _adresseCtrl.text,
      "profil": _profilCtrl.text,
      "formations": formations,
      "experiences": experiences,
      "competences": competences,
      "langues": langues,
      "centresInteret": centresInteret,
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _titreCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _adresseCtrl.dispose();
    _profilCtrl.dispose();
    _competenceCtrl.dispose();
    super.dispose();
  }
}


