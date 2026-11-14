import 'package:flutter/material.dart';
import '../data/aop_cours_complet.dart';

class AopCoursScreen extends StatelessWidget {
  const AopCoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(CoursAop.titre)),
      body: ListView.separated(
        itemCount: CoursAop.chapitres.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = CoursAop.chapitres[i];
          return ListTile(
            leading: CircleAvatar(child: Text('${c.numero}')),
            title: Text(c.titre),
            subtitle: Text('${c.sections.length} section(s)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AopChapitreScreen(chapitre: c),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AopChapitreScreen extends StatelessWidget {
  final ChapitreCours chapitre;
  const AopChapitreScreen({super.key, required this.chapitre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${chapitre.numero}. ${chapitre.titre}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [for (final s in chapitre.sections) _SectionView(section: s)],
      ),
    );
  }
}

class _SectionView extends StatelessWidget {
  final SectionCours section;
  const _SectionView({required this.section});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.titre,
              style: t.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
          const SizedBox(height: 8),
          for (final p in section.paragraphes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(p, style: t.textTheme.bodyMedium),
            ),
          for (final f in section.figures) FigureCoursWidget(figure: f),
          if (section.formules.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final f in section.formules)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SelectableText(
                        f,
                        style: t.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          if (section.exemple != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: cs.primary, width: 4)),
                color: cs.primaryContainer.withValues(alpha: 0.35),
              ),
              child: Text('Exemple. ${section.exemple}',
                  style: t.textTheme.bodyMedium),
            ),
        ],
      ),
    );
  }
}

