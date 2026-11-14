// Supabase Edge Function : assistant IA de Train Student
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const GEMINI_KEY = Deno.env.get("GEMINI_API_KEY")!;
const MODEL = Deno.env.get("GEMINI_MODEL") ?? "gemini-2.5-flash";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const DAILY_LIMIT = Number(Deno.env.get("AI_DAILY_LIMIT") ?? "20");

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const PERSONAS: Record<string, string> = {
  eleve: "Tu es un assistant scolaire bienveillant pour des élèves du Burkina Faso (collège et lycée, préparation au BEPC et au BAC). Ton ton est simple, encourageant et adapté à des adolescents. Explique la méthode étape par étape au lieu de donner seulement la réponse finale d'un exercice.",
  etudiant: "Tu es un assistant pédagogique pour des étudiants de licence et de master au Burkina Faso (filières scientifiques et de gestion). Explique les notions avec rigueur, détaille la démarche des calculs et donne des exemples concrets.",
  professionnel: "Tu es un assistant de préparation pour des candidats à des concours et des professionnels en formation au Burkina Faso. Explique les réponses aux QCM, donne des méthodes et des conseils pratiques.",
};

const RULES = "Réponds en français, de façon claire et complète, sans jamais t'arrêter au milieu d'une explication : explique la méthode étape par étape, puis donne le résultat. FORMULES : n'utilise JAMAIS de LaTeX (pas de $, pas de \\frac, pas de \\sqrt). Écris les formules en texte simple avec des symboles comme × ÷ √ ∫ ² ³ ₁ ₂ ⁺ ⁻ π ω Δ ≈ ≠ ≤ ≥ ∞, une formule par ligne, par exemple : Vs = −(R₂/R₁) · Ve. N'utilise pas de Markdown (pas de **, pas de #, pas de blocs de code). Fais les calculs numériques pas à pas et vérifie le résultat avant de répondre. Reste dans le cadre des études et de la formation : si la question n'a aucun rapport, refuse poliment. Si tu n'es pas sûr d'une réponse, dis-le au lieu d'inventer.";

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  try {
    const supabase = createClient(SUPABASE_URL, SERVICE_ROLE);

    // 1. Utilisateur connecté ?
    const token = (req.headers.get("Authorization") ?? "").replace("Bearer ", "");
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    if (authError || !user) return json({ error: "non_connecte" }, 401);

    // 2. TODO : vérifier ici l'essai de 3 jours ou l'abonnement actif

    // 3. Quota journalier
    const { data: allowed, error: quotaError } = await supabase.rpc(
      "increment_ai_usage",
      { p_user: user.id, p_limit: DAILY_LIMIT },
    );
    if (quotaError) throw quotaError;
    if (allowed === false) return json({ error: "quota_depasse" }, 429);

    // 4. Entrées nettoyées et limitées
    const body = await req.json();
    const question = String(body.question ?? "").slice(0, 1000);
    const chapterTitle = String(body.chapterTitle ?? "").slice(0, 200);
    const chapterText = String(body.chapterText ?? "").slice(0, 12000);
    const level = String(body.level ?? "").slice(0, 100);
    const space = String(body.space ?? "").slice(0, 20);
    const history: { role: string; text: string }[] = Array.isArray(body.history)
      ? body.history.slice(-6)
      : [];

    if (!question.trim()) return json({ error: "question_vide" }, 400);

    const persona = PERSONAS[space] ?? PERSONAS["etudiant"];
    const cours = chapterText.trim()
      ? `\n\nCHAPITRE : ${chapterTitle}\nCOURS :\n${chapterText}\nAppuie-toi d'abord sur ce cours.`
      : "";
    const systemPrompt = `${persona}\nClasse ou niveau : ${level}\n${RULES}${cours}`;

    const contents = [
      ...history.map((m) => ({
        role: m.role === "assistant" ? "model" : "user",
        parts: [{ text: String(m.text).slice(0, 2000) }],
      })),
      { role: "user", parts: [{ text: question }] },
    ];

    // 5. Appel Gemini (plus de place pour la réponse, réflexion limitée)
    const generationConfig = MODEL.startsWith("gemini-2.5")
      ? { temperature: 0.3, maxOutputTokens: 4096, thinkingConfig: { thinkingBudget: 1024 } }
      : { temperature: 0.3, maxOutputTokens: 4096 };

    const res = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json", "x-goog-api-key": GEMINI_KEY },
        body: JSON.stringify({
          systemInstruction: { parts: [{ text: systemPrompt }] },
          contents,
          generationConfig,
        }),
      },
    );

    if (!res.ok) {
      console.error("Gemini error", res.status, await res.text());
      return json({ error: "ia_indisponible" }, 502);
    }

    const data = await res.json();
    const cand = data?.candidates?.[0];
    let answer = (cand?.content?.parts ?? [])
      .map((p: { text?: string }) => p.text ?? "")
      .join("")
      .trim();
    if (!answer) answer = "Je n'ai pas pu générer de réponse.";
    if (cand?.finishReason === "MAX_TOKENS") {
      answer += "\n\n(La réponse a été coupée. Écris « continue » pour avoir la suite.)";
    }
    return json({ answer });
  } catch (e) {
    console.error(e);
    return json({ error: "erreur_serveur" }, 500);
  }
});