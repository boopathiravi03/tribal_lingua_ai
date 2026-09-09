import os

from dotenv import load_dotenv
from google import genai

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise RuntimeError(
        "GEMINI_API_KEY is missing from .env"
    )

client = genai.Client(api_key=api_key)

MODEL = "gemini-3.6-flash"


def translate_for_classroom(
    text: str,
    target_language: str,
    class_name: str,
    subject: str,
    lesson: str,
):
    prompt = f"""
You are TRIBAL LINGUA AI, an educational translation
assistant for Jharkhand primary schools.

Translate the teacher's Hindi sentence into {target_language}.

CLASS:
{class_name}

SUBJECT:
{subject}

LESSON:
{lesson}

TEACHER'S HINDI:
{text}

Instructions:

1. Translate for a primary-school child.
2. Preserve the educational meaning.
3. Do NOT perform literal word-by-word translation.
4. Use simple classroom language.
5. Do not add explanations.
6. Return only the translated sentence.
"""

    response = client.models.generate_content(
        model=MODEL,
        contents=prompt,
    )

    return response.text.strip()
