import os
import json

from dotenv import load_dotenv
from services.groq_service import generate_text

load_dotenv()


def generate_worksheet(
    class_name: str,
    subject: str,
    lesson: str,
    grade: str = "Grade 1",
    learning_outcome: str = "Recognises and counts numbers",
):

    prompt = f"""
You are an expert primary-school worksheet designer
aligned with NIPUN Bharat foundational numeracy and
literacy outcomes.

Create a simple worksheet for:

Grade: {grade}
Subject: {subject}
Lesson: {lesson}
Learning Outcome: {learning_outcome}

The worksheet is for foundational learning.

Return ONLY valid JSON.

Use exactly this structure:

{{
  "title": "...",
  "grade": "{grade}",
  "subject": "{subject}",
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
3. Questions must directly relate to the lesson and learning outcome.
4. Include exactly 5 questions.
5. Do not use markdown.
"""

    text = generate_text(
        prompt,
        max_tokens=3000,
    ).strip()

    if text.startswith("```"):
        text = text.replace("```json", "")
        text = text.replace("```", "")
        text = text.strip()

    return json.loads(text)
