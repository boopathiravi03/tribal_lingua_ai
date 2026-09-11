import time
from typing import Optional

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from services.groq_service import generate_text
from services.indictrans_service import IndicTransService


# ============================================================
# APP
# ============================================================

app = FastAPI(
    title="Tribal Lingua AI",
    description=(
        "AI-powered vernacular pedagogy and real-time "
        "translation platform for mother-tongue primary education."
    ),
    version="1.0.0",
)


# ============================================================
# CORS
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# SERVICES
# ============================================================

translation_service = IndicTransService()


# ============================================================
# MODELS
# ============================================================

class TranslateRequest(BaseModel):
    text: str = Field(..., min_length=1)
    source_language: str = "hi"
    target_language: str = "sat"


class LessonRequest(BaseModel):
    class_name: str = "Grade 1"
    subject: str = "Foundational Literacy"
    lesson: str = "Basic classroom lesson"
    target_language: str = "Santali"


class WorksheetRequest(BaseModel):
    class_name: str = "Grade 1"
    subject: str = "Foundational Literacy"
    lesson: str = "Basic lesson"
    grade: str = "Grade 1"
    learning_outcome: str = "Recognize and understand basic words"


class FlashcardRequest(BaseModel):
    class_name: str = "Grade 1"
    subject: str = "Foundational Literacy"
    lesson: str = "Basic vocabulary"


# ============================================================
# ROOT
# ============================================================

@app.get("/")
def root():
    return {
        "app": "Tribal Lingua AI",
        "status": "running",
        "version": "1.0.0",
        "translation_engine": "Groq AI",
        "target_language": "Santali",
    }


# ============================================================
# HEALTH
# ============================================================

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "tribal-lingua-ai",
        "translation_engine": "Groq AI",
    }


# ============================================================
# TRANSLATION
# ============================================================

@app.post("/translate")
def translate(request: TranslateRequest):

    start_time = time.perf_counter()

    try:

        translated_text = translation_service.translate(
            text=request.text,
            source_language=request.source_language,
            target_language=request.target_language,
        )

        latency = round(
            time.perf_counter() - start_time,
            3,
        )

        return {
            "success": True,
            "source_text": request.text,
            "translated_text": translated_text,
            "source_language": request.source_language,
            "target_language": request.target_language,
            "latency_seconds": latency,
        }

    except Exception as e:

        print("Translation error:", repr(e))

        raise HTTPException(
            status_code=500,
            detail=f"Translation failed: {str(e)}",
        )


# ============================================================
# LESSON GENERATOR
# ============================================================

@app.post("/lesson/generate")
def generate_lesson(request: LessonRequest):

    prompt = f"""
You are an AI pedagogy assistant for primary education.

Create a simple bilingual lesson for:

Class:
{request.class_name}

Subject:
{request.subject}

Lesson:
{request.lesson}

Target mother tongue:
{request.target_language}

The lesson must support foundational learning.

Return the result in this structure:

TITLE:
...

LEARNING OBJECTIVE:
...

TEACHER INTRODUCTION:
...

ACTIVITY:
...

ASSESSMENT:
...

TEACHER TIP:
...

MOTHER TONGUE SUPPORT:
...

Keep the content simple, practical and suitable
for a real classroom.
"""

    try:

        result = generate_text(
            prompt,
            temperature=0.4,
            max_tokens=1800,
        )

        return {
            "success": True,
            "class_name": request.class_name,
            "subject": request.subject,
            "lesson": request.lesson,
            "target_language": request.target_language,
            "content": result,
        }

    except Exception as e:

        print("Lesson generation error:", repr(e))

        raise HTTPException(
            status_code=500,
            detail=f"Lesson generation failed: {str(e)}",
        )


# ============================================================
# WORKSHEET GENERATOR
# ============================================================

@app.post("/worksheet/generate")
def generate_worksheet(request: WorksheetRequest):

    prompt = f"""
Create a primary-school bilingual worksheet.

GRADE:
{request.grade}

CLASS:
{request.class_name}

SUBJECT:
{request.subject}

LESSON:
{request.lesson}

NIPUN BHARAT LEARNING OUTCOME:
{request.learning_outcome}

Create simple activities suitable for foundational
literacy or numeracy.

Return:

WORKSHEET TITLE:
...

LEARNING OUTCOME:
...

QUESTION 1:
...

QUESTION 2:
...

QUESTION 3:
...

QUESTION 4:
...

QUESTION 5:
...

TEACHER INSTRUCTION:
...

ANSWER KEY:
...

Use child-friendly language.
Keep questions practical and easy to print.
"""

    try:

        result = generate_text(
            prompt,
            temperature=0.4,
            max_tokens=1800,
        )

        return {
            "success": True,
            "grade": request.grade,
            "subject": request.subject,
            "learning_outcome": request.learning_outcome,
            "content": result,
        }

    except Exception as e:

        print("Worksheet generation error:", repr(e))

        raise HTTPException(
            status_code=500,
            detail=f"Worksheet generation failed: {str(e)}",
        )


# ============================================================
# FLASHCARD GENERATOR
# ============================================================

@app.post("/flashcards/generate")
def generate_flashcards(request: FlashcardRequest):

    prompt = f"""
Create visual-learning flashcards for primary-school
children.

CLASS:
{request.class_name}

SUBJECT:
{request.subject}

LESSON:
{request.lesson}

Generate 6 flashcards.

For each flashcard provide:

CARD 1
WORD:
MEANING:
CHILD-FRIENDLY SENTENCE:
VISUAL IDEA:

CARD 2
WORD:
MEANING:
CHILD-FRIENDLY SENTENCE:
VISUAL IDEA:

Continue until CARD 6.

Focus on simple foundational vocabulary.
"""

    try:

        result = generate_text(
            prompt,
            temperature=0.5,
            max_tokens=1800,
        )

        return {
            "success": True,
            "class_name": request.class_name,
            "subject": request.subject,
            "lesson": request.lesson,
            "content": result,
        }

    except Exception as e:

        print("Flashcard generation error:", repr(e))

        raise HTTPException(
            status_code=500,
            detail=f"Flashcard generation failed: {str(e)}",
        )


# ============================================================
# STARTUP
# ============================================================

@app.on_event("startup")
async def startup_event():

    print("=" * 60)
    print("TRIBAL LINGUA AI BACKEND")
    print("=" * 60)
    print("FastAPI server started")
    print("Translation engine: Groq AI")
    print("Target language: Santali")
    print("=" * 60)
