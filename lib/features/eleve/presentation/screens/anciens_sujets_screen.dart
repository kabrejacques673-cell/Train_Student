import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:url_launcher/url_launcher.dart";

class SerieSujet {
  final String classe;
  final String titre;
  final String bucket;
  final String code;
  final IconData icon;
  final Color color;
  const SerieSujet(this.classe, this.titre, this.bucket, this.code, this.icon, this.color);
}

const List<SerieSujet> seriesSujets = [
  SerieSujet("3eme", "BEPC", "sujets-bepc", "bepc", Icons.menu_book_outlined, Color(0xFF1E88E5)),
  SerieSujet("Tle A4", "BAC serie A4", "sujets-bac", "a4", Icons.history_edu_outlined, Color(0xFFFB8C00)),
  SerieSujet("Tle C", "BAC serie C", "sujets-bac", "c", Icons.calculate_outlined, Color(0xFF3949AB)),
  SerieSujet("Tle D", "BAC serie D", "sujets-bac", "d", Icons.science_outlined, Color(0xFF00897B)),
  SerieSujet("Tle F1", "BAC serie F1", "sujets-bac", "f1", Icons.settings_outlined, Color(0xFF546E7A)),
  SerieSujet("Tle F2", "BAC serie F2", "sujets-bac", "f2", Icons.bolt_outlined, Color(0xFFF9A825)),
  SerieSujet("Tle F3", "BAC serie F3", "sujets-bac", "f3", Icons.electrical_services_outlined, Color(0xFFE53935)),
  SerieSujet("Tle F4", "BAC serie F4", "sujets-bac", "f4", Icons.home_work_outlined, Color(0xFF6D4C41)),
  SerieSujet("Tle G1", "BAC serie G1", "sujets-bac", "g1", Icons.account_balance_outlined, Color(0xFF1565C0)),
  SerieSujet("Tle G2", "BAC serie G2", "sujets-bac", "g2", Icons.bar_chart_outlined, Color(0xFF8E24AA)),
  SerieSujet("Tle H", "BAC serie H", "sujets-bac", "h", Icons.computer_outlined, Color(0xFF2E7D32)),
];

class AnciensSujetsScreen extends StatelessWidget {
  const AnciensSujetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Anciens sujets d examen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text("Choisis ta classe ou ta serie, puis l annee (2016 a 2026) et le tour.", style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 16),
        ...seriesSujets.map((s) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: s.color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Icon(s.icon, color: s.color),
                ),
                title: Text(s.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(s.classe),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnneesSujetsScreen(serie: s))),
              ),
            )),
      ],
    );
  }
}

class AnneesSujetsScreen extends StatelessWidget {
  final SerieSujet serie;
  const AnneesSujetsScreen({Key? key, required this.serie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final annees = List<int>.generate(11, (i) => 2026 - i);
    return Scaffold(
      appBar: AppBar(backgroundColor: serie.color, foregroundColor: Colors.white, title: Text(serie.titre)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: annees.length,
        itemBuilder: (context, i) {
          final annee = annees[i];
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ToursSujetsScreen(serie: serie, annee: annee))),
            child: Container(
              decoration: BoxDecoration(
                color: serie.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: serie.color.withOpacity(0.4)),
              ),
              child: Center(child: Text("$annee", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: serie.color))),
            ),
          );
        },
      ),
    );
  }
}

class ToursSujetsScreen extends StatefulWidget {
  final SerieSujet serie;
  final int annee;
  const ToursSujetsScreen({Key? key, required this.serie, required this.annee}) : super(key: key);

  @override
  State<ToursSujetsScreen> createState() => _ToursSujetsScreenState();
}

class _ToursSujetsScreenState extends State<ToursSujetsScreen> {
  bool chargement = true;
  String? erreur;
  Set<String> fichiers = {};

  String get dossier => "${widget.serie.code}/${widget.annee}";

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() {
      chargement = true;
      erreur = null;
    });
    try {
      final liste = await Supabase.instance.client.storage.from(widget.serie.bucket).list(path: dossier);
      if (!mounted) return;
      setState(() {
        fichiers = liste.map((f) => f.name).toSet();
        chargement = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        erreur = "Impossible de charger les sujets : $e";
        chargement = false;
      });
    }
  }

  Future<void> _ouvrir(String nomFichier) async {
    bool ok = false;
    try {
      final url = Supabase.instance.client.storage.from(widget.serie.bucket).getPublicUrl("$dossier/$nomFichier");
      ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      ok = false;
    }
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d ouvrir le sujet"), backgroundColor: Colors.red),
      );
    }
  }

  Widget _carte(String titre, String nomFichier) {
    final dispo = fichiers.contains(nomFichier);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        enabled: dispo,
        leading: Icon(Icons.picture_as_pdf, size: 36, color: dispo ? Colors.red : Colors.grey),
        title: Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dispo ? "Appuie pour ouvrir le PDF" : "Non disponible pour l instant"),
        trailing: dispo ? const Icon(Icons.open_in_new) : null,
        onTap: dispo ? () => _ouvrir(nomFichier) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget contenu;
    if (chargement) {
      contenu = const Center(child: CircularProgressIndicator());
    } else if (erreur != null) {
      contenu = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(erreur!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _charger, child: const Text("Reessayer")),
            ],
          ),
        ),
      );
    } else {
      contenu = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _carte("Sujet du 1er tour", "tour1.pdf"),
          _carte("Sujet du 2nd tour", "tour2.pdf"),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.serie.color,
        foregroundColor: Colors.white,
        title: Text("${widget.serie.titre} ${widget.annee}"),
      ),
      body: contenu,
    );
  }
}
