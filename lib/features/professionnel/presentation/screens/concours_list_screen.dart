import "package:flutter/material.dart";
import "../../data/concours_data.dart";
import "matieres_list_screen.dart";

class ConcoursListScreen extends StatelessWidget {
  final NiveauDiplome niveau;

  const ConcoursListScreen({super.key, required this.niveau});

  @override
  Widget build(BuildContext context) {
    final concours = ConcoursData.parNiveau(niveau);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: niveau.color,
        title: Text("Concours ${niveau.label}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: niveau.color.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(niveau.icon, color: niveau.color, size: 28),
                const SizedBox(width: 12),
                Text("${concours.length} concours disponibles", style: TextStyle(color: niveau.color, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: concours.length,
              itemBuilder: (context, index) {
                final c = concours[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: c.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                      child: Icon(c.icon, color: c.color, size: 24),
                    ),
                    title: Text(c.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.description, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.event, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("Composition : ${c.dateComposition}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ]),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MatieresListScreen(concours: c))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

