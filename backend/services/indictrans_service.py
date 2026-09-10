from services.groq_service import generate_text


class IndicTransService:

    def __init__(self):
        self.available = True

        print("Translation engine: Groq AI")
        print("Target language: Santali (Ol Chiki)")

    def translate(self, text: str) -> str:

        if not text or not text.strip():
            return ""

        prompt = f"""
Translate the following Hindi educational text into Santali.

Target language:
Santali (Ol Chiki script)

Important requirements:
1. Output ONLY the Santali translation.
2. Do not explain anything.
3. Do not add quotation marks.
4. Preserve numbers exactly.
5. Preserve names and mathematical symbols.
6. Use natural, simple Santali suitable for primary-school children.
7. Prefer Ol Chiki script.
8. Do not translate the meaning into another Indian language.

Hindi text:
{text}

Santali translation:
"""

        try:

            result = generate_text(
                prompt,
                system_prompt=(
                    "You are a multilingual Indian-language "
                    "translation assistant specializing in "
                    "Santali (Ol Chiki)."
                ),
                max_tokens=3000,
            )

            return result.strip()

        except Exception as e:
            print(f"Translation error: {e}")
            return text

    def translate_many(self, texts: list[str]) -> list[str]:

        results = []

        for text in texts:

            if not text or not text.strip():
                results.append("")
                continue

            results.append(
                self.translate(text)
            )

        return results
