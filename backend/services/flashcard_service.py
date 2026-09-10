import os
import json

from dotenv import load_dotenv
from services.groq_service import generate_text

load_dotenv()


def generate_flashcards(
    class_name: str,
    subject: str,
    lesson: str,
):

    prompt = f"""
You are an expert primary-school teaching assistant.

Create visual learning flashcards for:

Class: {class_name}
Subject: {subject}
Lesson: {lesson}

Create exactly 6 flashcards.

Return ONLY valid JSON.

Use this structure:

{{
  "title": "...",
  "cards": [
    {{
      "concept": "...",
      "label_hindi": "...",
      "visual_type": "count_objects",
      "object": "...",
      "count": 1
    }}
  ]
}}

Rules:

1. Flashcards must be suitable for young children.
2. Use simple concepts.
3. Each card must contain one visual concept.
4. For counting lessons, use familiar objects such as:
   mangoes, leaves, stones, flowers, pencils.
5. Use counts from 1 to 6.
6. Do not use markdown.
"""

    text = generate_text(
        prompt,
        max_tokens=2000,
    ).strip()

    if text.startswith("```"):
        text = text.replace("```json", "")
        text = text.replace("```", "")
        text = text.strip()

    return json.loads(text)
