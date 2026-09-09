import os
import json

from dotenv import load_dotenv
from google import genai

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise RuntimeError("GEMINI_API_KEY is missing")

client = genai.Client(api_key=api_key)

MODEL = "gemini-2.5-flash"


def generate_worksheet(
    class_name: str,
    subject: str,
    lesson: str,
):

    prompt = f"""
You are an expert primary-school worksheet designer.

Create a simple worksheet for:

Class: {class_name}
Subject: {subject}
Lesson: {lesson}

The worksheet is for foundational learning.

Return ONLY valid JSON.

Use exactly this structure:

{{
  "title": "...",
  "learning_outcome": "...",
  "questions": [
    {{
      "type": "number",
      "question": "...",
      "answer": "..."
    }},
    {{
      "type": "number",
      "question": "...",
      "answer": "..."
    }},
    {{
      "type": "number",
      "question": "...",
      "answer": "..."
    }},
    {{
      "type": "number",
      "question": "...",
      "answer": "..."
    }},
    {{
      "type": "number",
      "question": "...",
      "answer": "..."
    }}
  ]
}}

Rules:

1. Suitable for primary-school children.
2. Use simple language.
3. Questions must directly relate to the lesson.
4. Include exactly 5 questions.
5. Do not use markdown.
"""

    response = client.models.generate_content(
        model=MODEL,
        contents=prompt,
    )

    text = response.text.strip()

    if text.startswith("```"):
        text = text.replace("```json", "")
        text = text.replace("```", "")
        text = text.strip()

    return json.loads(text)
