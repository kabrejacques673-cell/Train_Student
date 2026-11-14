import 'cours_etudiant_data.dart';
import '../../../data/aop_cours_complet.dart';

const String _dossier =
    'assets/cours/etudiant/electronique_analogique_2/figures/';

String _cheminFigure(FigureCours f) {
  final nom = f.asset.split('/').last.replaceAll('.svg', '');
  return '${_dossier}aop-$nom.png';
}

List<BlocCours> _blocsDepuisAop() {
  final blocs = <BlocCours>[];
  for (final c in CoursAop.chapitres) {
    for (final s in c.sections) {
      final texte = StringBuffer();
      texte.writeAll(s.paragraphes, '\n\n');
      if (s.formules.isNotEmpty) {
        if (texte.isNotEmpty) texte.write('\n\n');
        texte.writeAll(s.formules, '\n');
      }
      if (s.exemple != null) {
        if (texte.isNotEmpty) texte.write('\n\n');
        texte.write('Exemple : ${s.exemple}');
      }
      final numerote = RegExp(r'^\d').hasMatch(s.titre);
      final titre = numerote ? s.titre : '${c.titre} : ${s.titre}';
      blocs.add(BlocCours(
        titre: titre,
        texte: texte.toString(),
        figure: s.figures.isNotEmpty ? _cheminFigure(s.figures.first) : null,
      ));
      for (final f in s.figures.skip(1)) {
        blocs.add(BlocCours(
          titre: 'Sch\u00e9ma compl\u00e9mentaire',
          texte: f.legende,
          figure: _cheminFigure(f),
        ));
      }
    }
  }
  return blocs;
}

final CoursEtudiant coursAopComplet = CoursEtudiant(
  titre: 'Amplificateur op\u00e9rationnel (AOP)',
  blocs: _blocsDepuisAop(),
);

