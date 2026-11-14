import "module_contenu_screen.dart";
import "../../data/cours_etudiant_data.dart";
import "package:flutter/material.dart";
import "package:train_student/screens/ai_tutor_screen.dart";
import "package:go_router/go_router.dart";
import "../../../../core/theme/app_theme.dart";
import "cv_etudiant_screen.dart";
import "../../../abonnement/presentation/screens/abonnement_screen.dart";

class Departement {
  final String nom;
  final String code;
  final IconData icon;
  final Color color;
  final String description;
  const Departement({required this.nom, required this.code, required this.icon, required this.color, required this.description});
}

class Filiere {
  final String nom;
  final String code;
  final IconData icon;
  final Color color;
  const Filiere({required this.nom, required this.code, required this.icon, required this.color});
}

class SectionModule {
  final String titre;
  final String description;
  final IconData icon;
  final Color color;
  const SectionModule({required this.titre, required this.description, required this.icon, required this.color});
}

const List<SectionModule> sectionsModule = [
  SectionModule(titre: "Cours / Resumes", description: "Fiches de cours et syntheses", icon: Icons.menu_book_outlined, color: Color(0xFF1E88E5)),
  SectionModule(titre: "TD + Corriges", description: "Travaux diriges avec corriges", icon: Icons.edit_note_outlined, color: Color(0xFF43A047)),
  SectionModule(titre: "Devoirs", description: "Devoirs maison a rendre", icon: Icons.assignment_outlined, color: Color(0xFFE53935)),
];

const List<Departement> departements = [
  Departement(nom: "Sciences et Technologie", code: "ST", icon: Icons.science_outlined, color: Color(0xFF1E88E5), description: "Informatique, Electronique, Genie Civil"),
  Departement(nom: "Sciences et Gestion", code: "SG", icon: Icons.business_outlined, color: Color(0xFF43A047), description: "Finance, Marketing, RH, Comptabilite"),
];

const Map<String, List<Filiere>> filieresByDepartement = {
  "ST": [
    Filiere(nom: "RIT / RSI", code: "RIT", icon: Icons.router_outlined, color: Color(0xFF1E88E5)),
    Filiere(nom: "EII", code: "EII", icon: Icons.memory_outlined, color: Color(0xFF8E24AA)),
    Filiere(nom: "Energie Nouvelle et Renouvelable", code: "GEENR", icon: Icons.bolt_outlined, color: Color(0xFFFFB300)),
    Filiere(nom: "Electronique", code: "ELT", icon: Icons.electrical_services_outlined, color: Color(0xFFE53935)),
    Filiere(nom: "Mintenance industrielle / GMP", code: "MIGMP", icon: Icons.build_outlined, color: Color(0xFF546E7A)),
    Filiere(nom: "Genie Civil", code: "GC", icon: Icons.foundation_outlined, color: Color(0xFFFF7043)),
  ],
  "SG": [
    Filiere(nom: "Marketing Gestion Commerciale", code: "MGC", icon: Icons.storefront_outlined, color: Color(0xFF43A047)),
    Filiere(nom: "Finance Comptabilite", code: "FC", icon: Icons.account_balance_outlined, color: Color(0xFF1E88E5)),
    Filiere(nom: "Gestion des Ressources Humaines", code: "GRH", icon: Icons.people_outlined, color: Color(0xFFFF7043)),
  ],
};

const Map<String, Map<String, List<String>>> modulesByFiliereAndNiveau = {
  "RIT": {
    "L1": [
      "Droit",
      "Mathematiques Generales 1",
      "Mathematiques appliquÃ©es 1",
      "Electricite Generale 1",
      "Electricite Generale 2",
      "Programmation (C et Python)",
      "Algorithmique",
      "Reseaux Informatiques et Infrastructure Physique",
      "Informatique",
      "SystÃ¨me d\'exploitation Windows",
      "Architecture et fonctionnement des ordinateurs",
      "Technologie IP",
      "Administration SystÃ¨me sous windows",
      "Electronique Analogiques 1",
      "Electronique numÃ©rique et systÃ¨me programmÃ© 1",

    ],


    "L2": [
      "Mathematiques Generales 2",
      "Programmation Orientee Objet (Java)",
      "Base de Donnees",
      "Systeme dExploitation",
      "Telecoms 1: Transmission de signeaux analogiques,numÃ©riques et communication",
      "Telecoms 2: TÃ©lÃ©phonie (TRC et PBX)",
      "Electronique numérique et système programmé 2",
      "Mathematiques appliquÃ©es 2",
      "Electricite Generale 2",
      "Programmation (C et Python)",
      "Programmation OrientÃ©e Objet (Java)",
      "Technologie web",
      "Base de donnÃ©es",
      "SystÃ¨me d'exploitation et programmation systÃ¨me",
      "TÃ©lÃ©coms 3: Base des radiocommunications / RÃ©seaux mobiles",
      "Traitement de signal",
      "Administration rÃ©seaux et systÃ¨me (cisco / lunix)",
      "Technologies rÃ©seaux",

    ],
    "L3": [" module en cours"],

    "Master 1":[""],

    "Master 2":[""],
  },
  "EII":{
    "L1": ["Droit",
      "Mathematiques Generales 1",
      "Electricite Generale 1",
      "Programmation (C et Python)",
      "Algorithmique",
      "Electronique Analogiques 1",
      "Electronique numÃ©rique et systÃ¨me programmÃ© 1",
      "Electronique de puissance 1",


    ],
    "L2": [
      "Mathematiques Generales 2",
      "Programmation Orientee Objet (Java)",
      "Systeme dExploitation",
      "Telecoms 1",
      "Electronique numÃ©rique et systÃ¨me programmÃ© 2",
      "Mathematiques appliquÃ©es 2",
      "Electricite Generale 2",
      "Programmation (C et Python)",
      "Automatiques",
      "Electronique de puissance 2",
      "Orientation et mÃ©thodes de maintenance",
      "Cnstruction Ã©lectrique",
      "Maintenance audiovisuelle",
      "RÃ©seuax informatiques",
      "Traintement de signal",
      "Automatisation industriels",


    ],
    "L3": [" module en cours"],


  },
  "Energie Nouvelle et Renouvelable":
  {

    "L1": [
      "module en cours",
    ],

    "L2": [
      "module en cours",
    ],

    "L3": [
      "module en cours",
    ],

    "Masteur 1":[
      "module en cours"
    ],
  },

  "Electronique":
  {
    "L1": [
      "Droit",
      "Mathematiques Generales 1",
      "Mathematiques appliquÃ©es 1",
      "Electricite Generale 1",
      "Programmation (C et Python)",
      "Algorithmique",
      "SystÃ¨me d\'exploitation Windows",
      "Architecture et fonctionnement des ordinateurs",
      "Electronique Analogiques 1",
      "Electronique numÃ©rique et systÃ¨me programmÃ© 1",
      "Informatiques",
      "MÃ©canique GÃ©rÃ©rale",
      "Instruction et mesures",
      "Technique schÃ©ma et construction",
      "Electronique de puissance 1",
      "Electrotecnique 1",
    ],

  },







};


class EtudiantHomePage extends StatefulWidget {
  const EtudiantHomePage({super.key});

  @override
  State<EtudiantHomePage> createState() => _EtudiantHomePageState();
}

class _EtudiantHomePageState extends State<EtudiantHomePage> {
  int _currentIndex = 0;
  Departement? _selectedDepartement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _currentIndex == 4 ? null : AppBar(
        backgroundColor: _selectedDepartement?.color ?? AppTheme.etudiantColor,
        title: const Text("Espace Etudiant"),
        actions: [
          if (_selectedDepartement != null)
            IconButton(icon: const Icon(Icons.swap_horiz), onPressed: () => setState(() => _selectedDepartement = null)),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => context.go("/login")),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _selectedDepartement == null ? _buildChoixDepartement() : _buildAccueil(),
          _buildModulesOnglet(),
          const CvEtudiantScreen(),
          _buildProfil(),
          AiTutorScreen(chapterTitle: "Assistant IA", chapterText: "", level: _selectedDepartement?.nom ?? "Etudiant (licence et master)", space: "etudiant"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _selectedDepartement?.color ?? AppTheme.etudiantColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), activeIcon: Icon(Icons.book), label: "Modules"),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: "Mon CV"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), activeIcon: Icon(Icons.smart_toy), label: "Assistant IA"),
        ],
      ),
    );
  }

  Widget _buildChoixDepartement() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Choisir un departement", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ...departements.map((dept) => _DepartementCard(departement: dept, onTap: () => setState(() => _selectedDepartement = dept))),
        ],
      ),
    );
  }

  Widget _buildAccueil() {
    final filieres = filieresByDepartement[_selectedDepartement!.code] ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_selectedDepartement!.color, _selectedDepartement!.color.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Bonjour !", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(_selectedDepartement!.nom, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                ])),
                Icon(_selectedDepartement!.icon, color: Colors.white, size: 48),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("Filieres", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...filieres.map((f) => _FiliereCard(filiere: f)),
        ],
      ),
    );
  }

  Widget _buildModulesOnglet() {
    if (_selectedDepartement == null) {
      return const Center(child: Text("Selectionnez un departement dabord"));
    }
    final filieres = filieresByDepartement[_selectedDepartement!.code] ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filieres.length,
      itemBuilder: (context, index) => _FiliereExpandable(filiere: filieres[index]),
    );
  }

  Widget _buildProfil() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(radius: 48, backgroundColor: _selectedDepartement?.color ?? AppTheme.etudiantColor, child: const Icon(Icons.person, size: 48, color: Colors.white)),
          const SizedBox(height: 16),
          Text(_selectedDepartement?.nom ?? "Espace Etudiant", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ListTile(leading: const Icon(Icons.subscriptions_outlined), title: const Text("Mon abonnement"), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AbonnementScreen(espace: "etudiant")))),
          const Divider(),
          ListTile(leading: const Icon(Icons.swap_horiz), title: const Text("Changer de departement"), onTap: () => setState(() { _selectedDepartement = null; _currentIndex = 0; })),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Se deconnecter", style: TextStyle(color: Colors.red)), onTap: () => context.go("/login")),
        ],
      ),
    );
  }
}

class _DepartementCard extends StatelessWidget {
  final Departement departement;
  final VoidCallback onTap;
  const _DepartementCard({required this.departement, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(width: 60, height: 60, decoration: BoxDecoration(color: departement.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)), child: Icon(departement.icon, color: departement.color, size: 32)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(departement.nom, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(departement.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ])),
                Icon(Icons.arrow_forward_ios, size: 16, color: departement.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FiliereCard extends StatelessWidget {
  final Filiere filiere;
  const _FiliereCard({required this.filiere});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: filiere.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(filiere.icon, color: filiere.color)),
        title: Text(filiere.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: filiere.color),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NiveauSelectionPage(filiere: filiere))),
      ),
    );
  }
}

class _FiliereExpandable extends StatefulWidget {
  final Filiere filiere;
  const _FiliereExpandable({required this.filiere});

  @override
  State<_FiliereExpandable> createState() => _FiliereExpandableState();
}

class _FiliereExpandableState extends State<_FiliereExpandable> {
  bool _expanded = false;
  String _selectedNiveau = "L1";
  final List<String> _niveaux = ["L1", "L2", "L3"];

  @override
  Widget build(BuildContext context) {
    final modules = ajouterModulesCommuns(widget.filiere.code, _selectedNiveau, modulesByFiliereAndNiveau[widget.filiere.code]?[_selectedNiveau] ?? []);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.filiere.icon, color: widget.filiere.color),
            title: Text(widget.filiere.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            trailing: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _niveaux.length,
                itemBuilder: (context, index) {
                  final n = _niveaux[index];
                  final isSel = n == _selectedNiveau;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedNiveau = n),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: isSel ? widget.filiere.color : Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                        child: Text(n, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSel ? Colors.white : Colors.black87)),
                      ),
                    ),
                  );
                },
              ),
            ),
            ...modules.map((module) => ListTile(
              dense: true,
              leading: Icon(Icons.folder_outlined, color: widget.filiere.color, size: 20),
              title: Text(module, style: const TextStyle(fontSize: 13)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ModuleDetailPage(moduleName: module, filiereColor: widget.filiere.color))),
            )),
          ],
        ],
      ),
    );
  }
}

class NiveauSelectionPage extends StatelessWidget {
  final Filiere filiere;
  const NiveauSelectionPage({super.key, required this.filiere});
  static const List<String> _niveaux = ["L1", "L2", "L3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: filiere.color, title: Text(filiere.nom)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _niveaux.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(_niveaux[index], style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ModulesListPage(filiere: filiere, niveau: _niveaux[index]))),
          ),
        ),
      ),
    );
  }
}

class ModulesListPage extends StatelessWidget {
  final Filiere filiere;
  final String niveau;
  const ModulesListPage({super.key, required this.filiere, required this.niveau});

  @override
  Widget build(BuildContext context) {
    final modules = ajouterModulesCommuns(filiere.code, niveau, modulesByFiliereAndNiveau[filiere.code]?[niveau] ?? []);
    return Scaffold(
      appBar: AppBar(backgroundColor: filiere.color, title: Text("${filiere.nom} - $niveau")),
      body: modules.isEmpty
          ? const Center(child: Text("Aucun module disponible"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: modules.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(modules[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ModuleDetailPage(moduleName: modules[index], filiereColor: filiere.color))),
                ),
              ),
            ),
    );
  }
}

class ModuleDetailPage extends StatelessWidget {
  final String moduleName;
  final Color filiereColor;
  const ModuleDetailPage({super.key, required this.moduleName, required this.filiereColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: filiereColor, title: Text(moduleName)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sectionsModule.length,
        itemBuilder: (context, index) {
          final section = sectionsModule[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(section.icon, color: section.color, size: 26),
              title: Text(section.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(section.description, style: const TextStyle(fontSize: 12)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ModuleContenuScreen(moduleName: moduleName, section: section.titre, couleur: filiereColor))),
            ),
          );
        },
      ),
    );
  }
}


