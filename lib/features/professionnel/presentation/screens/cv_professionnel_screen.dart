import "../../../../core/services/cv_pdf_service.dart";
import "../../../../core/services/profil_service.dart";
import "package:flutter/material.dart";

class CvProfessionnelScreen extends StatefulWidget {
  const CvProfessionnelScreen({super.key});

  @override
  State<CvProfessionnelScreen> createState() => _CvProfessionnelScreenState();
}

class _CvProfessionnelScreenState extends State<CvProfessionnelScreen> {
  int _selectedTab = 0;

  String nom = "";
  String titre = "";
  String telephone = "";
  String email = "";
  String adresse = "";
  String motivations = "";
  List<Map<String, String>> experiences = [];
  List<Map<String, String>> formations = [];
  List<String> competences = [];

  bool cvCree = false;

  @override
  void initState() {
    super.initState();
    _chargerCv();
  }

  Future<void> _chargerCv() async {
    try {
      final d = await ProfilService.chargerCv("cv_professionnel");
      if (d == null || !mounted) return;
      setState(() {
        nom = d["nom"] ?? "";
        titre = d["titre"] ?? "";
        telephone = d["telephone"] ?? "";
        email = d["email"] ?? "";
        adresse = d["adresse"] ?? "";
        motivations = d["motivations"] ?? "";
        experiences = ProfilService.listeMaps(d["experiences"]);
        formations = ProfilService.listeMaps(d["formations"]);
        competences = ProfilService.listeTextes(d["competences"]);
        cvCree = true;
      });
    } catch (e) {
      debugPrint("Chargement CV impossible : $e");
    }
  }

  Future<void> _sauvegarderCv(Map<String, dynamic> data) async {
    try {
      await ProfilService.sauvegarderCv("cv_professionnel", {
        "nom": data["nom"],
        "titre": data["titre"],
        "telephone": data["telephone"],
        "email": data["email"],
        "adresse": data["adresse"],
        "motivations": data["motivations"],
        "experiences": data["experiences"],
        "formations": data["formations"],
        "competences": data["competences"],
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
        backgroundColor: Colors.orange.shade700,
        title: const Text("Mon CV", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: cvCree ? [
          IconButton(icon: const Icon(Icons.picture_as_pdf, color: Colors.white), onPressed: _telechargerPDF),
        ] : null,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.orange.shade700,
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
        onPressed: () => _ouvrirCreerCV(context),
        backgroundColor: Colors.orange.shade700,
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
            decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                CircleAvatar(radius: 32, backgroundColor: Colors.white24, child: const Icon(Icons.person, size: 36, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nom.isEmpty ? "Votre Nom" : nom, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(titre.isEmpty ? "Titre / Poste vise" : titre, style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConseilsTab() {
    final bonsConseils = [
      "Adaptez votre CV au concours vise (mentionnez son nom precisement)",
      "Mettez en avant vos diplomes et niveaux d etudes requis",
      "Indiquez clairement vos motivations pour le poste ou le concours",
      "Utilisez un format clair et professionnel, sans fioritures",
      "Verifiez que vos coordonnees sont a jour et joignables",
      "Mentionnez toute experience meme non remuneree (stages, benevolat)",
      "Relisez plusieurs fois pour eviter les fautes d orthographe",
      "Restez factuel : dates, diplomes, resultats precis",
    ];
    final erreursAEviter = [
      "Oublier de mentionner le concours ou poste vise",
      "Utiliser un CV generique non adapte au concours",
      "Exagerer ou inventer des experiences",
      "Fournir des coordonnees incorrectes ou obsoletes",
      "Depasser 2 pages pour un CV de concours",
      "Negliger la mise en page et la lisibilite",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Conseils pour un bon CV de concours", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
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
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.info_outline, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(child: Text("Voici un exemple de CV adapte pour un concours de la fonction publique. Inspirez-vous de cette structure !", style: TextStyle(fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8)]),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 28, backgroundColor: Colors.white24, child: const Icon(Icons.person, size: 30, color: Colors.white)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Issouf OUEDRAOGO", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("Candidat au Concours de la Fonction Publique", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("+226 76 00 00 00", style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text("issouf.ouedraogo@email.com", style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text("Bobo-Dioulasso, Burkina Faso", style: TextStyle(color: Colors.white70, fontSize: 11)),
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
                      _modeleSection("MOTIVATIONS", "Titulaire d un BAC serie D, je souhaite integrer la fonction publique afin de mettre mes competences au service de l administration. Rigoureux et motive, je suis pret a m investir pleinement dans la preparation et la reussite de ce concours."),
                      _modeleSectionList("FORMATION", ["BAC Serie D - Lycee Ouezzin Coulibaly - 2022", "BEPC - College Municipal - 2019"]),
                      _modeleSectionList("EXPERIENCES", ["Agent de saisie - Mairie de Bobo-Dioulasso - 2023 (3 mois)\nSaisie de documents administratifs, classement des dossiers."]),
                      _modeleChips("COMPETENCES", ["Redaction administrative", "Microsoft Office", "Sens de l organisation", "Rigueur", "Travail en equipe"]),
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
          Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
          Divider(color: Colors.orange.shade700),
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
          Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
          Divider(color: Colors.orange.shade700),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("- ", style: TextStyle(color: Colors.orange.shade700, fontSize: 16)),
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
          Text(titre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
          Divider(color: Colors.orange.shade700),
          Wrap(spacing: 8, runSpacing: 8, children: items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange.shade200)),
            child: Text(item, style: TextStyle(fontSize: 12, color: Colors.orange.shade700)),
          )).toList()),
        ],
      ),
    );
  }

  void _ouvrirCreerCV(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CreerCvProfessionnelScreen(
      nomInitial: nom,
      titreInitial: titre,
      telephoneInitial: telephone,
      emailInitial: email,
      adresseInitial: adresse,
      motivationsInitial: motivations,
      experiencesInitial: experiences,
      formationsInitial: formations,
      competencesInitial: competences,
      onSave: (data) {
        _sauvegarderCv(data);
        setState(() {
          nom = data["nom"] ?? "";
          titre = data["titre"] ?? "";
          telephone = data["telephone"] ?? "";
          email = data["email"] ?? "";
          adresse = data["adresse"] ?? "";
          motivations = data["motivations"] ?? "";
          experiences = List<Map<String, String>>.from(data["experiences"] ?? []);
          formations = List<Map<String, String>>.from(data["formations"] ?? []);
          competences = List<String>.from(data["competences"] ?? []);
          cvCree = true;
          _selectedTab = 0;
        });
      },
    )));
  }

  Future<void> _telechargerPDF() async {
    try {
      await CvPdfService.professionnel(
        nom: nom,
        titre: titre,
        telephone: telephone,
        email: email,
        adresse: adresse,
        motivations: motivations,
        experiences: experiences,
        formations: formations,
        competences: competences,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF impossible : $e"), backgroundColor: Colors.red),
      );
    }
  }
}

class CreerCvProfessionnelScreen extends StatefulWidget {
  final String nomInitial;
  final String titreInitial;
  final String telephoneInitial;
  final String emailInitial;
  final String adresseInitial;
  final String motivationsInitial;
  final List<Map<String, String>> experiencesInitial;
  final List<Map<String, String>> formationsInitial;
  final List<String> competencesInitial;
  final Function(Map<String, dynamic>) onSave;

  const CreerCvProfessionnelScreen({
    super.key,
    required this.nomInitial,
    required this.titreInitial,
    required this.telephoneInitial,
    required this.emailInitial,
    required this.adresseInitial,
    required this.motivationsInitial,
    required this.experiencesInitial,
    required this.formationsInitial,
    required this.competencesInitial,
    required this.onSave,
  });

  @override
  State<CreerCvProfessionnelScreen> createState() => _CreerCvProfessionnelScreenState();
}

class _CreerCvProfessionnelScreenState extends State<CreerCvProfessionnelScreen> {
  late TextEditingController _nomCtrl;
  late TextEditingController _titreCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _adresseCtrl;
  late TextEditingController _motivationsCtrl;
  late TextEditingController _competenceCtrl;

  late List<Map<String, String>> experiences;
  late List<Map<String, String>> formations;
  late List<String> competences;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.nomInitial);
    _titreCtrl = TextEditingController(text: widget.titreInitial);
    _telCtrl = TextEditingController(text: widget.telephoneInitial);
    _emailCtrl = TextEditingController(text: widget.emailInitial);
    _adresseCtrl = TextEditingController(text: widget.adresseInitial);
    _motivationsCtrl = TextEditingController(text: widget.motivationsInitial);
    _competenceCtrl = TextEditingController();
    experiences = List.from(widget.experiencesInitial);
    formations = List.from(widget.formationsInitial);
    competences = List.from(widget.competencesInitial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
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
                  CircleAvatar(radius: 48, backgroundColor: Colors.orange.shade100, child: Icon(Icons.person, size: 48, color: Colors.orange.shade400)),
                  Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 16, backgroundColor: Colors.orange.shade700, child: const Icon(Icons.camera_alt, color: Colors.white, size: 16))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text("Appuyez pour changer la photo", style: TextStyle(fontSize: 12, color: Colors.grey))),
            const SizedBox(height: 24),
            _sectionTitle("Informations personnelles"),
            _buildField(_nomCtrl, "Nom complet *", Icons.person),
            _buildField(_titreCtrl, "Titre / Concours vise *", Icons.work_outline),
            _buildField(_telCtrl, "Telephone *", Icons.phone),
            _buildField(_emailCtrl, "Email *", Icons.email),
            _buildField(_adresseCtrl, "Adresse", Icons.location_on),
            const SizedBox(height: 20),
            _sectionTitle("Motivations"),
            TextField(
              controller: _motivationsCtrl,
              maxLines: 4,
              decoration: _inputDecoration("Expliquez vos motivations pour ce concours ou poste", null),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Experiences"),
            ...experiences.map((e) => _itemCard("${e["poste"]} - ${e["structure"]}", () {
              setState(() => experiences.remove(e));
            })),
            _addButton("Ajouter une experience", () => _ajouterExperience()),
            const SizedBox(height: 20),
            _sectionTitle("Formation"),
            ...formations.map((f) => _itemCard("${f["diplome"]} - ${f["etablissement"]} - ${f["annee"]}", () {
              setState(() => formations.remove(f));
            })),
            _addButton("Ajouter une formation", () => _ajouterFormation()),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
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
                backgroundColor: Colors.orange.shade50,
              )).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sauvegarder,
                icon: const Icon(Icons.save),
                label: const Text("Sauvegarder mon CV"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
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
      child: Text(titre, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade700)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.orange.shade200)),
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
          border: Border.all(color: Colors.orange.shade700),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.add_circle_outline, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
        ])),
      ),
    );
  }

  void _ajouterExperience() {
    final posteCtrl = TextEditingController();
    final structureCtrl = TextEditingController();
    final periodeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text("Experience", style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogField(posteCtrl, "Poste / Mission *"),
        const SizedBox(height: 12),
        _dialogField(structureCtrl, "Structure / Entreprise"),
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
              setState(() => experiences.add({"poste": posteCtrl.text, "structure": structureCtrl.text, "periode": periodeCtrl.text, "description": descCtrl.text}));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
          child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  void _ajouterFormation() {
    final diplomeCtrl = TextEditingController();
    final etablissementCtrl = TextEditingController();
    final anneeCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Text("Formation", style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogField(diplomeCtrl, "Diplome *"),
        const SizedBox(height: 12),
        _dialogField(etablissementCtrl, "Etablissement *"),
        const SizedBox(height: 12),
        _dialogField(anneeCtrl, "Annee d obtention"),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler", style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          onPressed: () {
            if (diplomeCtrl.text.isNotEmpty) {
              setState(() => formations.add({"diplome": diplomeCtrl.text, "etablissement": etablissementCtrl.text, "annee": anneeCtrl.text}));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
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
      "motivations": _motivationsCtrl.text,
      "experiences": experiences,
      "formations": formations,
      "competences": competences,
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
    _motivationsCtrl.dispose();
    _competenceCtrl.dispose();
    super.dispose();
  }
}


