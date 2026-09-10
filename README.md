# Tribal Lingua AI

Mother-tongue AI assistant for Jharkhand primary schools. Built with Flutter and FastAPI.

## Architecture

- **Frontend:** Flutter app with classroom assistant, lesson generator, worksheet generator, and visual flashcards.
- **Backend:** FastAPI service with Groq for pedagogy/lesson generation and IndicTrans2 for Hindi ↔ Santali translation.
- **Offline-first:** Lesson packs, worksheets, and flashcards are designed for sync-then-offline use on low-cost Android tablets.

## Prerequisites

- Flutter SDK
- Python 3.11+
- Android device or emulator
- Windows/macOS/Linux for backend development
- Groq API key
- Hugging Face access for `ai4bharat/indictrans2-indic-indic-dist-320M`

## Flutter Setup

1. Install dependencies:
   ```powershell
   flutter pub get
   ```

2. Update `lib/services/api_service.dart` if needed:
   - Emulator: keep `http://10.0.2.2:8000`
   - Physical device: change to your PC's LAN IP, e.g. `http://192.168.1.10:8000`

3. Run the app:
   ```powershell
   flutter run
   ```

## Backend Setup

1. Open PowerShell in the backend folder:
   ```powershell
   cd A:\tribal_lingua_ai\backend
   ```

2. Create and activate a virtual environment:
   ```powershell
   python -m venv venv
   .\venv\Scripts\Activate.ps1
   ```

3. Install dependencies:
   ```powershell
   pip install -r requirements.txt
   ```

4. Configure environment:
    - Rename or edit `.env`
    - Set `GROQ_API_KEY`
    - If using IndicTrans2 gated model, set `HF_TOKEN` as well

5. Start the server:
   ```powershell
   python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

6. Verify:
   - Health: http://127.0.0.1:8000/health
   - Swagger: http://127.0.0.1:8000/docs

## Backend Endpoints

- `GET /` — app status
- `GET /health` — health check
- `POST /translate` — Hindi to Santali translation
- `POST /lesson/generate` — bilingual lesson generation
- `POST /worksheet/generate` — bilingual worksheet generation
- `POST /flashcards/generate` — visual flashcard generation

## Key Backend Services

- `backend/services/indictrans_service.py` — IndicTrans2 Hindi ↔ Santali
- `backend/services/lesson_service.py` — Groq lesson generation
- `backend/services/worksheet_service.py` — Groq worksheet generation
- `backend/services/flashcard_service.py` — Groq flashcard generation
- `backend/services/pdf_service.py` — ReportLab worksheet PDF generation

## Important Notes

- Do not commit `backend/.env` or `backend/venv/`
- IndicTrans2 model download requires Hugging Face access approval
- Ol Chiki PDF rendering requires a proper Ol Chiki font; current PDF service uses Latin fallback
- Offline operation requires pre-synced lesson packs; full offline AI translation is not yet implemented

## Demo Flow

1. Teacher selects class, subject, lesson, and target language
2. Use **Classroom Assistant** for Hindi speech → Santali translation
3. Use **AI Lesson Generator** for bilingual lesson content
4. Use **Worksheet Generator** for printable bilingual worksheets
5. Use **Visual Flashcards** for classroom activity cards
