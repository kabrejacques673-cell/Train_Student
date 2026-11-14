import 'package:flutter/material.dart';
import 'package:train_student/data/aop_cours_complet.dart';
import 'package:train_student/data/aop_cours_texte.dart';
import 'package:train_student/screens/ai_tutor_screen.dart';

const _indigo = Color(0xFF3F3D9E);

/// Liste des chapitres du cours AOP.
class AopLecteurScreen extends StatelessWidget {
  const AopLecteurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CoursAop.titre),
        backgroundColor: _indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: CoursAop.chapitres.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = CoursAop.chapitres[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _indigo,
              foregroundColor: Colors.white,
              child: Text("${c.numero}"),
            ),
            title: Text(c.titre),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AopChapitreScreen(chapitre: c),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Lecture d'un chapitre, avec le bouton du tuteur IA.
class AopChapitreScreen extends StatelessWidget {
  final ChapitreCours chapitre;
  const AopChapitreScreen({super.key, required this.chapitre});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final s in chapitre.sections) {
      children.add(const SizedBox(height: 16));
      children.add(Text(
        s.titre,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: _indigo),
      ));
      for (final f in s.figures) {
        children.add(FigureCoursWidget(figure: f));
      }
      for (final p in s.paragraphes) {
        children.add(Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(p, style: const TextStyle(fontSize: 15, height: 1.4)),
        ));
      }
      for (final f in s.formules) {
        children.add(Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _indigo.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            f,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ));
      }
      if (s.exemple != null) {
        children.add(Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text("Exemple : ${s.exemple}"),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Chapitre ${chapitre.numero} : ${chapitre.titre}"),
        backgroundColor: _indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        children: children,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.chat),
        label: const Text("Pose ta question"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AiTutorScreen(
                chapterTitle: "Chapitre ${chapitre.numero} : ${chapitre.titre}",
                chapterText: texteChapitreAop(chapitre),
                level: CoursAop.matiere,
              ),
            ),
          );
        },
      ),
    );
  }
}