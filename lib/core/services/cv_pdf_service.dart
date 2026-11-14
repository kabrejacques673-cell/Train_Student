import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:printing/printing.dart";

class _Ligne {
  final String titre;
  final String detail;
  final String description;
  _Ligne(this.titre, this.detail, this.description);
}

class CvPdfService {
  static String _s(String t) {
    return t
        .replaceAll("\u2019", "'")
        .replaceAll("\u2018", "'")
        .replaceAll("\u2013", "-")
        .replaceAll("\u2014", "-")
        .replaceAll("\u2026", "...")
        .replaceAll("\u0153", "oe")
        .replaceAll("\u0152", "OE");
  }

  static String _v(Map<String, String> m, String k) => (m[k] ?? "").trim();

  static String _joindre(List<String> parts) =>
      parts.where((p) => p.trim().isNotEmpty).join(" - ");

  static String _nomFichier(String prefixe, String nom) {
    final propre = nom.trim().replaceAll(RegExp(r"[^A-Za-z0-9]+"), "_");
    return propre.isEmpty ? "$prefixe.pdf" : "${prefixe}_$propre.pdf";
  }

  static pw.Widget _entete(String nom, String titre, List<String> contacts, PdfColor couleur) {
    final utiles = contacts.where((c) => c.trim().isNotEmpty).toList();
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: couleur,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _s(nom.trim().isEmpty ? "Votre nom" : nom.trim()),
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          ),
          if (titre.trim().isNotEmpty)
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 3),
              child: pw.Text(_s(titre.trim()), style: pw.TextStyle(fontSize: 12, color: PdfColors.white)),
            ),
          if (utiles.isNotEmpty)
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 8),
              child: pw.Text(_s(utiles.join("   |   ")), style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
            ),
        ],
      ),
    );
  }

  static pw.Widget _titreSection(String texte, PdfColor couleur) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(top: 14, bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _s(texte.toUpperCase()),
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: couleur),
          ),
          pw.Divider(color: couleur, thickness: 1.2, height: 6),
        ],
      ),
    );
  }

  static List<pw.Widget> _sectionTexte(String titre, String texte, PdfColor c) {
    if (texte.trim().isEmpty) return [];
    return [
      _titreSection(titre, c),
      pw.Text(_s(texte.trim()), style: pw.TextStyle(fontSize: 10.5)),
    ];
  }

  static List<pw.Widget> _sectionLignes(String titre, List<_Ligne> lignes, PdfColor c) {
    if (lignes.isEmpty) return [];
    return [
      _titreSection(titre, c),
      ...lignes.map((l) => pw.Padding(
            padding: pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(_s(l.titre), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                if (l.detail.isNotEmpty)
                  pw.Text(_s(l.detail), style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                if (l.description.isNotEmpty)
                  pw.Text(_s(l.description), style: pw.TextStyle(fontSize: 10)),
              ],
            ),
          )),
    ];
  }

  static List<pw.Widget> _sectionPuces(String titre, List<String> items, PdfColor c) {
    final propres = items.where((i) => i.trim().isNotEmpty).toList();
    if (propres.isEmpty) return [];
    return [
      _titreSection(titre, c),
      pw.Wrap(
        spacing: 6,
        runSpacing: 6,
        children: propres
            .map((i) => pw.Container(
                  padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: c, width: 0.8),
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
                  ),
                  child: pw.Text(_s(i), style: pw.TextStyle(fontSize: 10, color: c)),
                ))
            .toList(),
      ),
    ];
  }

  static Future<void> _afficher(
    PdfColor couleur,
    String nom,
    String titre,
    List<String> contacts,
    List<pw.Widget> sections,
    String fichier,
  ) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (context) => [
        _entete(nom, titre, contacts, couleur),
        ...sections,
      ],
    ));
    final bytes = await doc.save();
    await Printing.layoutPdf(onLayout: (format) async => bytes, name: fichier);
  }

  static Future<void> etudiant({
    required String nom,
    required String titre,
    required String telephone,
    required String email,
    required String adresse,
    required String profil,
    required List<Map<String, String>> formations,
    required List<Map<String, String>> experiences,
    required List<String> competences,
    required List<Map<String, String>> langues,
    required List<String> centresInteret,
  }) {
    final c = PdfColor.fromInt(0xFF1E88E5);
    final sections = <pw.Widget>[
      ..._sectionTexte("Profil", profil, c),
      ..._sectionLignes(
        "Formation",
        formations
            .map((f) => _Ligne(_v(f, "diplome"), _joindre([_v(f, "etablissement"), _v(f, "periode")]), ""))
            .toList(),
        c,
      ),
      ..._sectionLignes(
        "Experiences / Stages",
        experiences
            .map((e) => _Ligne(_v(e, "poste"), _joindre([_v(e, "entreprise"), _v(e, "periode")]), _v(e, "description")))
            .toList(),
        c,
      ),
      ..._sectionPuces("Competences", competences, c),
      ..._sectionLignes(
        "Langues",
        langues.map((l) => _Ligne(_joindre([_v(l, "langue"), _v(l, "niveau")]), "", "")).toList(),
        c,
      ),
      ..._sectionPuces("Centres d'interet", centresInteret, c),
    ];
    return _afficher(c, nom, titre, [telephone, email, adresse], sections, _nomFichier("CV_Etudiant", nom));
  }

  static Future<void> professionnel({
    required String nom,
    required String titre,
    required String telephone,
    required String email,
    required String adresse,
    required String motivations,
    required List<Map<String, String>> experiences,
    required List<Map<String, String>> formations,
    required List<String> competences,
  }) {
    final c = PdfColor.fromInt(0xFFF57C00);
    final sections = <pw.Widget>[
      ..._sectionTexte("Motivations", motivations, c),
      ..._sectionLignes(
        "Formation",
        formations
            .map((f) => _Ligne(_v(f, "diplome"), _joindre([_v(f, "etablissement"), _v(f, "annee")]), ""))
            .toList(),
        c,
      ),
      ..._sectionLignes(
        "Experiences",
        experiences
            .map((e) => _Ligne(_v(e, "poste"), _joindre([_v(e, "structure"), _v(e, "periode")]), _v(e, "description")))
            .toList(),
        c,
      ),
      ..._sectionPuces("Competences", competences, c),
    ];
    return _afficher(c, nom, titre, [telephone, email, adresse], sections, _nomFichier("CV_Professionnel", nom));
  }
}
