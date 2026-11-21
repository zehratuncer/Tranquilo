import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { worryText } = await req.json();

    if (!worryText || typeof worryText !== "string") {
      return new Response(
        JSON.stringify({ error: "worryText is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const apiKey = Deno.env.get("GEMINI_API_KEY");
    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: "GEMINI_API_KEY secret is not set" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const systemPrompt = `Sen Tranquilo adlı dokunsal wellness ve zihinsel rahatlama uygulamasının bilişsel süzgeç asistanısın.
Kullanıcının girdiği kaygı cümlesini analiz et ve Bilişsel Davranışçı Terapi (BDT) ilkelerinden ilham alarak düşünceyi küçük parçalara ayıracak tam 3 adet soru üret.
Sorular:
1. Kesinlik/Kanıt sorgulama ("Bu düşünce kesin bir gerçek mi yoksa bir tahmin mi? Kanıtın ne?")
2. Perspektif/Arkadaş açısı ("Bunu çok sevdiğin bir arkadaşın yaşasaydı ona ne söylerdin?") veya alternatif senaryo
3. En kötü senaryo ile başa çıkma ("En kötüsü olsa bile bununla nasıl başa çıkabilirsin?")

Kurallar:
- Kesinlikle teşhis, terapi veya tıbbi garanti verme.
- Sade, şefkatli, sakin ve Türkçe bir dil kullan.
- Çıktıyı SADECE JSON formatında döndür. Format: {"questions": ["Soru 1", "Soru 2", "Soru 3"]}`;

    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`;

    const geminiResponse = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [
          {
            role: "user",
            parts: [
              { text: systemPrompt },
              { text: `Kullanıcının Kaygısı: "${worryText}"` }
            ]
          }
        ],
        generationConfig: {
          responseMimeType: "application/json",
          temperature: 0.7,
        }
      })
    });

    if (!geminiResponse.ok) {
      const errText = await geminiResponse.text();
      console.error("Gemini API error:", errText);
      return new Response(
        JSON.stringify({ error: "Gemini API failed", details: errText }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const geminiData = await geminiResponse.json();
    const candidateText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text;

    let parsed = { questions: [] };
    if (candidateText) {
      try {
        parsed = JSON.parse(candidateText);
      } catch (e) {
        console.error("JSON parse error from Gemini output:", candidateText, e);
      }
    }

    return new Response(JSON.stringify(parsed), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("Internal Server Error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
