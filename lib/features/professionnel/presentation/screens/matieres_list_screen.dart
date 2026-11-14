import "package:flutter/material.dart";
import "../../data/concours_data.dart";
import "qcm_screen.dart";

class MatieresListScreen extends StatelessWidget {
  final ConcoursModel concours;

  const MatieresListScreen({super.key, required this.concours});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: concours.color,
        title: Text(concours.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: concours.color.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(concours.description, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.event, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("Composition : ${concours.dateComposition}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.how_to_reg, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("Inscription : ${concours.dateInscription}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ConcoursData.matieres.length,
              itemBuilder: (context, index) {
                final matiere = ConcoursData.matieres[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: matiere.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                      child: Icon(matiere.icon, color: matiere.color),
                    ),
                    title: Text(matiere.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("${matiere.totalQuestions} questions", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QcmScreen(matiere: matiere, concours: concours))),
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

