from services.groq_service import generate_text


class IndicTransService:

    def __init__(self):
        print("Translation engine: Groq AI")

    # ========================================================
    # HINDI ↔ SANTALI
    # ========================================================

    def translate(
        self,
        text: str,
        source_language: str = "hi",
        target_language: str = "sat",
    ) -> str:

        if not text or not text.strip():
            return ""

        source_language = source_language.lower().strip()
        target_language = target_language.lower().strip()

        if source_language in ["hi", "hindi"]:
            source_name = "Hindi"

        elif source_language in ["sat", "santali"]:
            source_name = "Santali"

        else:
            source_name = source_language

        if target_language in ["sat", "santali"]:
            target_name = "Santali"
            script_instruction = (
                "Write Santali using Ol Chiki script whenever possible."
            )

        elif target_language in ["hi", "hindi"]:
            target_name = "Hindi"
            script_instruction = (
                "Write Hindi using Devanagari script."
            )

        else:
            target_name = target_language
            script_instruction = ""

        prompt = f"""
You are a professional translator for a primary-school
mother-tongue education application in India.

Translate the following educational sentence.

SOURCE LANGUAGE:
{source_name}

TARGET LANGUAGE:
{target_name}

IMPORTANT RULES:
1. Preserve the original meaning.
2. Use simple language suitable for primary-school children.
3. Do not explain the translation.
4. Do not add extra information.
5. Return ONLY the translated sentence.
6. {script_instruction}

TEXT:
{text}
"""

        return generate_text(
            prompt,
            temperature=0.2,
            max_tokens=500,
        )
