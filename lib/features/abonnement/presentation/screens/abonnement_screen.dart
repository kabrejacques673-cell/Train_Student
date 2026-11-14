import "package:flutter/material.dart";
import "../../../../core/services/cinetpay_service.dart";

// PRIX PAR DEFAUT - A MODIFIER FACILEMENT ICI
const Map<String, Map<String, int>> prixAbonnement = {
  "eleve": {"mensuel": 300, "annuel": 2400},
  "etudiant": {"mensuel": 500, "annuel": 4000},
  "professionnel": {"mensuel": 1000, "annuel": 8000},
};

const Map<String, Map<String, dynamic>> infoEspace = {
  "eleve": {"nom": "Espace Eleve", "couleur": Color(0xFF43A047), "icon": Icons.school},
  "etudiant": {"nom": "Espace Etudiant", "couleur": Color(0xFF1E88E5), "icon": Icons.school_sharp},
  "professionnel": {"nom": "Espace Professionnel", "couleur": Color(0xFFF97316), "icon": Icons.work},
};

class AbonnementScreen extends StatefulWidget {
  final String espace; // "eleve", "etudiant" ou "professionnel"

  const AbonnementScreen({super.key, required this.espace});

  @override
  State<AbonnementScreen> createState() => _AbonnementScreenState();
}

class _AbonnementScreenState extends State<AbonnementScreen> {
  String formuleSelectionnee = "mensuel";
  String? moyenPaiementSelectionne;

  @override
  Widget build(BuildContext context) {
    final info = infoEspace[widget.espace]!;
    final couleur = info["couleur"] as Color;
    final prixMensuel = prixAbonnement[widget.espace]!["mensuel"]!;
    final prixAnnuel = prixAbonnement[widget.espace]!["annuel"]!;
    final prixAffiche = formuleSelectionnee == "mensuel" ? prixMensuel : prixAnnuel;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: couleur,
        title: const Text("Mon abonnement", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bandeau info espace
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [couleur, couleur.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(info["icon"] as IconData, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(info["nom"] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text("Debloquez tout le contenu", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Choix formule
            const Text("Choisissez votre formule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _FormuleCard(
                  titre: "Mensuel",
                  prix: prixMensuel,
                  selectionne: formuleSelectionnee == "mensuel",
                  couleur: couleur,
                  onTap: () => setState(() => formuleSelectionnee = "mensuel"),
                )),
                const SizedBox(width: 12),
                Expanded(child: _FormuleCard(
                  titre: "Annuel",
                  prix: prixAnnuel,
                  selectionne: formuleSelectionnee == "annuel",
                  couleur: couleur,
                  badge: "Economisez ${((1 - prixAnnuel / (prixMensuel * 12)) * 100).round()}%",
                  onTap: () => setState(() => formuleSelectionnee = "annuel"),
                )),
              ],
            ),
            const SizedBox(height: 24),

            // Recapitulatif prix
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total a payer", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text("$prixAffiche FCFA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: couleur)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Moyen de paiement
            const Text("Choisissez votre moyen de paiement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _MoyenPaiementTile(
              nom: "Orange Money",
              logo: "assets/images/paiement/orange_money.jpg",
              selectionne: moyenPaiementSelectionne == "orange",
              onTap: () => setState(() => moyenPaiementSelectionne = "orange"),
            ),
            _MoyenPaiementTile(
              nom: "Moov Money",
              logo: "assets/images/paiement/moov_money.png",
              selectionne: moyenPaiementSelectionne == "moov",
              onTap: () => setState(() => moyenPaiementSelectionne = "moov"),
            ),
            _MoyenPaiementTile(
              nom: "Telecel Money",
              logo: "assets/images/paiement/telecel_money.png",
              selectionne: moyenPaiementSelectionne == "telecel",
              onTap: () => setState(() => moyenPaiementSelectionne = "telecel"),
            ),
            _MoyenPaiementTile(
              nom: "Wave",
              logo: "assets/images/paiement/wave.png",
              selectionne: moyenPaiementSelectionne == "wave",
              onTap: () => setState(() => moyenPaiementSelectionne = "wave"),
            ),
            const SizedBox(height: 32),

            // Bouton payer
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (moyenPaiementSelectionne == null || _paiementEnCours) ? null : () => _lancerPaiement(context, couleur, prixAffiche),
                style: ElevatedButton.styleFrom(
                  backgroundColor: couleur,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  moyenPaiementSelectionne == null ? "Choisissez un moyen de paiement" : "Payer $prixAffiche FCFA",
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _paiementEnCours = false;

  void _lancerPaiement(BuildContext context, Color couleur, int prix) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmation du paiement"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Montant : $prix FCFA"),
            const SizedBox(height: 8),
            Text("Moyen de paiement : ${_nomMoyenPaiement(moyenPaiementSelectionne!)}"),
            const SizedBox(height: 16),
            const Text("Vous allez etre redirige vers la page de paiement securisee.", style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _traiterPaiement(context, couleur, prix);
            },
            style: ElevatedButton.styleFrom(backgroundColor: couleur),
            child: const Text("Confirmer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _traiterPaiement(BuildContext context, Color couleur, int prix) async {
    setState(() => _paiementEnCours = true);

    final transactionId = "TS_${widget.espace}_${DateTime.now().millisecondsSinceEpoch}";

    final result = await CinetPayService.initierPaiement(
      transactionId: transactionId,
      montant: prix,
      description: "Abonnement ${widget.espace} - $formuleSelectionnee",
      nomClient: "Utilisateur",
      telephoneClient: "00000000",
      emailClient: "utilisateur@trainstudent.app",
    );

    setState(() => _paiementEnCours = false);

    if (!context.mounted) return;

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Redirection vers le paiement..."), backgroundColor: couleur),
      );
      // TODO: ouvrir result["payment_url"] dans un navigateur ou WebView
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Erreur lors du paiement"), backgroundColor: Colors.red),
      );
    }
  }

  String _nomMoyenPaiement(String code) {
    switch (code) {
      case "orange": return "Orange Money";
      case "moov": return "Moov Money";
      case "telecel": return "Telecel Money";
      case "wave": return "Wave";
      default: return "";
    }
  }
}

class _FormuleCard extends StatelessWidget {
  final String titre;
  final int prix;
  final bool selectionne;
  final Color couleur;
  final String? badge;
  final VoidCallback onTap;

  const _FormuleCard({required this.titre, required this.prix, required this.selectionne, required this.couleur, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectionne ? couleur.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selectionne ? couleur : Colors.grey.shade300, width: selectionne ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(titre, style: TextStyle(fontWeight: FontWeight.bold, color: selectionne ? couleur : Colors.black)),
                if (selectionne) ...[const Spacer(), Icon(Icons.check_circle, color: couleur, size: 18)],
              ],
            ),
            const SizedBox(height: 8),
            Text("$prix FCFA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: selectionne ? couleur : Colors.black87)),
            if (badge != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text(badge!, style: const TextStyle(fontSize: 10, color: Colors.green)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MoyenPaiementTile extends StatelessWidget {
  final String nom;
  final String logo;
  final bool selectionne;
  final VoidCallback onTap;

  const _MoyenPaiementTile({required this.nom, required this.logo, required this.selectionne, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selectionne ? Colors.blue : Colors.grey.shade200, width: selectionne ? 2 : 1),
        ),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(logo, width: 40, height: 40, fit: BoxFit.contain, errorBuilder: (context, error, stack) => const Icon(Icons.payment, size: 32, color: Colors.grey))),
            const SizedBox(width: 12),
            Expanded(child: Text(nom, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
            if (selectionne) const Icon(Icons.check_circle, color: Colors.blue) else const Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}



