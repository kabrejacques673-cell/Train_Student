import 'aop_cours_complet.dart';

/// Transforme un chapitre du cours AOP en texte brut pour le tuteur IA.
String texteChapitreAop(ChapitreCours c) {
  final b = StringBuffer();
  b.writeln("Chapitre ${c.numero} : ${c.titre}");
  for (final s in c.sections) {
    b.writeln("");
    b.writeln("## ${s.titre}");
    for (final p in s.paragraphes) {
      b.writeln(p);
    }
    for (final f in s.formules) {
      b.writeln("Formule : $f");
    }
    if (s.exemple != null) {
      b.writeln("Exemple : ${s.exemple}");
    }
  }
  return b.toString();
}