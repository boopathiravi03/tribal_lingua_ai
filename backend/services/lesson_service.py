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


def generate_lesson(
    class_name: str,
    subject: str,
    lesson: str,
    target_language: str,
):

    prompt = f"""
You are an expert primary-school pedagogy assistant
for the Jharkhand Mother Tongue Based Multilingual
Education programme.

Create a simple classroom lesson for:

Class: {class_name}
Subject: {subject}
Lesson: {lesson}
Target language: {target_language}

The lesson must be appropriate for primary-school
children and use simple classroom activities.

Return ONLY valid JSON.

Use exactly this structure:

{{
  "learning_objective": "...",
  "teacher_script_hindi": "...",
  "activity": {{
      "title": "...",
      "instructions_hindi": "...",
      "materials": ["...", "..."]
  }},
  "assessment": [
      "...",
      "...",
      "..."
  ],
  "home_activity": "..."
}}

Requirements:

1. Keep the learning objective measurable.
2. Teacher script should be short and classroom-friendly.
3. Activity should use simple locally available objects.
4. Assessment should contain 3 questions/tasks.
5. Do not include markdown.
6. Do not include comments.
"""

    response = client.models.generate_content(
        model=MODEL,
        contents=prompt,
    )

    text = response.text.strip()

    # Remove accidental markdown fences
    if text.startswith("```"):
        text = text.replace("```json", "")
        text = text.replace("```", "")
        text = text.strip()

    return json.loads(text)
