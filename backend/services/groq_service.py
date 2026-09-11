import os
from typing import Optional

from dotenv import load_dotenv
from groq import Groq

load_dotenv()


# ============================================================
# GROQ CONFIGURATION
# ============================================================

GROQ_API_KEY = os.getenv("GROQ_API_KEY")

MODEL = os.getenv(
    "GROQ_MODEL",
    "openai/gpt-oss-20b",
)


if not GROQ_API_KEY:
    print("WARNING: GROQ_API_KEY is not configured.")

client: Optional[Groq] = None

if GROQ_API_KEY:
    client = Groq(
        api_key=GROQ_API_KEY,
    )


# ============================================================
# GENERATE TEXT
# ============================================================

def generate_text(
    prompt: str,
    model: str = MODEL,
    temperature: float = 0.3,
    max_tokens: int = 1500,
) -> str:

    if client is None:
        raise RuntimeError(
            "GROQ_API_KEY is missing. "
            "Add GROQ_API_KEY to the backend environment variables."
        )

    response = client.chat.completions.create(
        model=model,
        messages=[
            {
                "role": "system",
                "content": (
                    "You are an AI assistant for Tribal Lingua AI, "
                    "an educational application for primary-school "
                    "children learning through their mother tongue."
                ),
            },
            {
                "role": "user",
                "content": prompt,
            },
        ],
        temperature=temperature,
        max_tokens=max_tokens,
    )

    content = response.choices[0].message.content

    if not content:
        raise RuntimeError("Groq returned an empty response.")

    return content.strip()
