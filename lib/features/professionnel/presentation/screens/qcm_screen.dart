import "package:flutter/material.dart";
import "../../data/concours_data.dart";

class QcmScreen extends StatefulWidget {
  final MatiereModel matiere;
  final ConcoursModel concours;

  const QcmScreen({super.key, required this.matiere, required this.concours});

  @override
  State<QcmScreen> createState() => _QcmScreenState();
}

class _QcmScreenState extends State<QcmScreen> {
  int currentIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;

  late List<QuestionQCM> questions;

  @override
  void initState() {
    super.initState();
    questions = ConcoursData.questionsParMatiere[widget.matiere.id] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: widget.matiere.color, title: Text(widget.matiere.nom)),
        body: const Center(child: Text("Questions en cours de preparation...")),
      );
    }

    if (currentIndex >= questions.length) {
      return _buildResultatScreen();
    }

    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.matiere.color,
        title: Text("${widget.matiere.nom} (${currentIndex + 1}/${questions.length})", style: const TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade200,
              color: widget.matiere.color,
            ),
            const SizedBox(height: 24),
            Text(question.question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...List.generate(question.options.length, (i) {
              final isSelected = selectedAnswer == i;
              final isCorrect = i == question.bonneReponse;
              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade300;

              if (answered) {
                if (isCorrect) {
                  bgColor = Colors.green.shade50;
                  borderColor = Colors.green;
                } else if (isSelected && !isCorrect) {
                  bgColor = Colors.red.shade50;
                  borderColor = Colors.red;
                }
              } else if (isSelected) {
                borderColor = widget.matiere.color;
              }

              return GestureDetector(
                onTap: answered ? null : () => setState(() {
                  selectedAnswer = i;
                }),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: isSelected || (answered && isCorrect) ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(question.options[i], style: const TextStyle(fontSize: 14))),
                      if (answered && isCorrect) const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      if (answered && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red, size: 20),
                    ],
                  ),
                ),
              );
            }),
            if (answered) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(question.explication, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer == null ? null : () {
                  if (!answered) {
                    setState(() {
                      answered = true;
                      if (selectedAnswer == question.bonneReponse) score++;
                    });
                  } else {
                    setState(() {
                      currentIndex++;
                      selectedAnswer = null;
                      answered = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: widget.matiere.color, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: Text(
                  answered ? (currentIndex < questions.length - 1 ? "Question suivante" : "Voir les resultats") : "Valider",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultatScreen() {
    final pourcentage = questions.isEmpty ? 0 : (score / questions.length * 100).round();
    return Scaffold(
      appBar: AppBar(backgroundColor: widget.matiere.color, title: const Text("Resultats", style: TextStyle(color: Colors.white))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: widget.matiere.color.withValues(alpha: 0.15),
                child: Text("$pourcentage%", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.matiere.color)),
              ),
              const SizedBox(height: 24),
              Text("Score : $score / ${questions.length}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(widget.matiere.nom, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    currentIndex = 0;
                    score = 0;
                    selectedAnswer = null;
                    answered = false;
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: widget.matiere.color, padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text("Recommencer", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Retour aux matieres"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

