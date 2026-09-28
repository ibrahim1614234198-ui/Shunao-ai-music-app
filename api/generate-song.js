export default async function handler(req, res) {
  // CORS
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(200).end();
  }

  if (req.method !== "POST") {
    return res.status(405).json({
      error: "Method not allowed",
    });
  }

  try {
    const { prompt } = req.body || {};

    if (!prompt || !prompt.trim()) {
      return res.status(400).json({
        error: "Prompt is required",
      });
    }

    const apiKey = process.env.RUNWARE_API_KEY;

    if (!apiKey) {
      return res.status(500).json({
        error: "RUNWARE_API_KEY is not configured",
      });
    }

    const response = await fetch("https://api.runware.ai/v1", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify([
        {
          taskType: "audioInference",
          taskUUID: crypto.randomUUID(),
          model: "runware:ace-step@v1.5-turbo",
          positivePrompt: prompt.trim(),
          duration: 30,
          outputType: "URL",
          outputFormat: "MP3",
        },
      ]),
    });

    const data = await response.json();

    if (!response.ok) {
      return res.status(response.status).json({
        error: data?.error || "Runware request failed",
      });
    }

    if (!data?.data?.[0]?.audioURL) {
      return res.status(500).json({
        error: "No audio URL returned from Runware",
        details: data,
      });
    }

    return res.status(200).json({
      success: true,
      audioUrl: data.data[0].audioURL,
    });
  } catch (error) {
    return res.status(500).json({
      error: error.message || "Internal server error",
    });
  }
}
