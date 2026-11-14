import "package:http/http.dart" as http;
import "dart:convert";

class CinetPayService {
  // A REMPLACER avec tes vraies cles CinetPay
  static const String apiKey = "TA_CLE_API_ICI";
  static const String siteId = "TON_SITE_ID_ICI";
  static const String baseUrl = "https://api-checkout.cinetpay.com/v2/payment";

  static Future<Map<String, dynamic>> initierPaiement({
    required String transactionId,
    required int montant,
    required String description,
    required String nomClient,
    required String telephoneClient,
    required String emailClient,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "apikey": apiKey,
          "site_id": siteId,
          "transaction_id": transactionId,
          "amount": montant,
          "currency": "XOF",
          "description": description,
          "customer_name": nomClient,
          "customer_phone_number": telephoneClient,
          "customer_email": emailClient,
          "channels": "ALL",
          "return_url": "https://trainstudent.app/paiement-retour",
          "notify_url": "https://trainstudent.app/paiement-notification",
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["code"] == "201") {
        return {
          "success": true,
          "payment_url": data["data"]["payment_url"],
          "transaction_id": transactionId,
        };
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Erreur lors de l initialisation du paiement",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Erreur de connexion : $e",
      };
    }
  }

  static Future<Map<String, dynamic>> verifierPaiement(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse("https://api-checkout.cinetpay.com/v2/payment/check"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "apikey": apiKey,
          "site_id": siteId,
          "transaction_id": transactionId,
        }),
      );

      final data = jsonDecode(response.body);
      final statut = data["data"]?["status"];

      return {
        "success": statut == "ACCEPTED",
        "statut": statut,
      };
    } catch (e) {
      return {"success": false, "message": "Erreur : $e"};
    }
  }
}
