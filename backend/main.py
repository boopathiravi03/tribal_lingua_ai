import time

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from services.ai_service import translate_for_classroom
from services.indictrans_service import IndicTransService
from services.lesson_service import generate_lesson
from services.worksheet_service import generate_worksheet
from services.flashcard_service import generate_flashcards


app = FastAPI(
    title="Tribal Lingua AI",
    version="1.0.0",
)


indictrans = IndicTransService()


class TranslationRequest(BaseModel):
    text: str
    source_language: str = "Hindi"
    target_language: str = "Santhali"

    class_name: str = "Class 2"
    subject: str = "Foundational Mathematics"
    lesson: str = "Counting 1–10"


class LessonRequest(BaseModel):
    class_name: str
    subject: str
    lesson: str
    target_language: str = "Santali"


class WorksheetRequest(BaseModel):
    class_name: str
    subject: str
    lesson: str
    target_language: str = "Santali"


class FlashcardRequest(BaseModel):
    class_name: str
    subject: str
    lesson: str
    target_language: str = "Santali"


@app.get("/")
def root():
    return {
        "app": "Tribal Lingua AI",
        "status": "running",
        "version": "1.0.0",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
    }


@app.post("/translate")
def translate(request: TranslationRequest):

    start_time = time.perf_counter()

    try:

        translated_text = indictrans.translate(
            request.text
        )

        elapsed = time.perf_counter() - start_time

        return {
            "success": True,

            "source_text": request.text,

            "source_language":
                request.source_language,

            "target_language":
                request.target_language,

            "translated_text":
                translated_text,

            "translation_engine":
                "IndicTrans2",

            "source_code":
                "hin_Deva",

            "target_code":
                "sat_Olck",

            "latency_ms":
                round(elapsed * 1000),

            "context": {
                "class":
                    request.class_name,

                "subject":
                    request.subject,

                "lesson":
                    request.lesson,
            },
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@app.post("/lesson/generate")
def create_lesson(request: LessonRequest):

    try:

        lesson = generate_lesson(
            class_name=request.class_name,
            subject=request.subject,
            lesson=request.lesson,
            target_language=request.target_language,
        )

        activity = lesson["activity"]

        texts = [
            lesson["learning_objective"],
            lesson["teacher_script_hindi"],
            activity["instructions_hindi"],
            *lesson["assessment"],
            lesson["home_activity"],
        ]

        translations = indictrans.translate_many(
            texts
        )

        index = 0

        learning_objective_target = translations[index]
        index += 1

        teacher_script_target = translations[index]
        index += 1

        activity_target = translations[index]
        index += 1

        assessment_target = translations[
            index:index + len(lesson["assessment"])
        ]

        index += len(lesson["assessment"])

        home_activity_target = translations[index]

        return {

            "success": True,

            "class_name":
                request.class_name,

            "subject":
                request.subject,

            "lesson":
                request.lesson,

            "target_language":
                request.target_language,

            "learning_objective": {
                "hindi":
                    lesson["learning_objective"],

                "target":
                    learning_objective_target,
            },

            "teacher_script": {
                "hindi":
                    lesson["teacher_script_hindi"],

                "target":
                    teacher_script_target,
            },

            "activity": {
                "title":
                    activity["title"],

                "instructions": {
                    "hindi":
                        activity["instructions_hindi"],

                    "target":
                        activity_target,
                },

                "materials":
                    activity["materials"],
            },

            "assessment": [

                {
                    "hindi": h,
                    "target": t,
                }

                for h, t in zip(
                    lesson["assessment"],
                    assessment_target,
                )
            ],

            "home_activity": {
                "hindi":
                    lesson["home_activity"],

                "target":
                    home_activity_target,
            },

            "translation_engine":
                "IndicTrans2",
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@app.post("/worksheet/generate")
def create_worksheet(request: WorksheetRequest):

    try:

        worksheet = generate_worksheet(
            class_name=request.class_name,
            subject=request.subject,
            lesson=request.lesson,
        )

        questions = worksheet["questions"]

        hindi_texts = [
            worksheet["title"],
            worksheet["learning_outcome"],
            *[
                question["question"]
                for question in questions
            ],
        ]

        translations = indictrans.translate_many(
            hindi_texts
        )

        return {
            "success": True,

            "title": {
                "hindi": worksheet["title"],
                "target": translations[0],
            },

            "learning_outcome": {
                "hindi":
                    worksheet["learning_outcome"],

                "target":
                    translations[1],
            },

             "questions": [
                {
                    "number": index + 1,
                    "hindi":
                        question["question"],
                    "target":
                        translations[index + 2],
                    "answer":
                        question["answer"],
                }
                for index, question
                in enumerate(questions)
            ],

            "translation_engine":
                "IndicTrans2",
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


@app.post("/flashcards/generate")
def create_flashcards(
    request: FlashcardRequest
):

    try:

        data = generate_flashcards(
            class_name=request.class_name,
            subject=request.subject,
            lesson=request.lesson,
        )

        cards = data["cards"]

        texts = [
            card["label_hindi"]
            for card in cards
        ]

        translations = (
            indictrans.translate_many(texts)
        )

        bilingual_cards = []

        for card, translation in zip(
            cards,
            translations,
        ):

            bilingual_cards.append({

                "concept":
                    card["concept"],

                "label_hindi":
                    card["label_hindi"],

                "label_santali":
                    translation,

                "visual_type":
                    card["visual_type"],

                "object":
                    card["object"],

                "count":
                    card["count"],
            })

        return {

            "success": True,

            "title":
                data["title"],

            "cards":
                bilingual_cards,

            "translation_engine":
                "IndicTrans2",
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )
