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
    const { worryText, smallAction, answers } = await req.json();

    const apiKey = Deno.env.get("GEMINI_API_KEY");
    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: "GEMINI_API_KEY secret is not set" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const systemPrompt = `Sen Tranquilo adlı dokunsal wellness uygulamasının kapanış asistanısın.
Kullanıcı kaygısını dev bir kaya olarak gördü, dokunarak kırdı, parçalara ayırıp soruları cevapladı ve son olarak mikro bir eylem adımı belirledi.
Görevin: Kullanıcıya 1-2 cümlelik, şefkatli, sakinleştirici, gerçekçi ve yükünü hafifleten bir kapanış rahatlama mesajı üretmek.

Kurallar:
- Asla "kaygın tamamen bitti/yok oldu" gibi abartılı garantiler verme.
- Düşüncenin yok olmadığını ancak artık daha hafif, daha taşınabilir olduğunu ve kullanıcının kontrolünde olduğunu hissettir.
- Kullanıcının seçtiği küçük adımı nazikçe pekiştir.
- Çıktıyı SADECE JSON formatında döndür. Format: {"reliefMessage": "Mesajınız"}`;

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
              {
                text: JSON.stringify({
                  kaygi: worryText,
                  cevaplananSorular: answers,
                  secilenKucukAdim: smallAction,
                })
              }
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

    let parsed = { reliefMessage: "Düşünce tamamen yok olmadı; ama artık zihninde daha hafif ve daha taşınabilir." };
    if (candidateText) {
      try {
        parsed = JSON.parse(candidateText);
      } catch (e) {
        console.error("JSON parse error:", candidateText, e);
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
