class DemoDataService {
  // ============================================================
  // APP DEMO INFORMATION
  // ============================================================

  static const String teacherName = "Sita Kumari";
  static const String schoolName = "Government Primary School";
  static const String district = "Dumka, Jharkhand";

  // ============================================================
  // SAMPLE TRANSLATIONS
  // ============================================================

  static final List<Map<String, String>> translations = [
    {
      "hindi": "सब बच्चे बैठ जाओ।",
      "santali": "ᱡᱚᱛᱚ ᱦᱚᱲ ᱠᱚ ᱫᱩᱵ ᱢᱮ।",
    },
    {
      "hindi": "तुम्हारा नाम क्या है?",
      "santali": "ᱟᱢᱟᱜ ᱧᱩᱛ ᱪᱮᱫ ᱠᱟᱱᱟ?",
    },
    {
      "hindi": "यह एक पेड़ है।",
      "santali": "ᱱᱚᱣᱟ ᱢᱤᱫ ᱫᱟᱨᱮ ᱠᱟᱱᱟ।",
    },
    {
      "hindi": "मेरे पास पाँच आम हैं।",
      "santali": "ᱤᱧ ᱞᱟᱜᱤᱱ ᱢᱚᱬᱮ ᱟᱢ ᱢᱮᱱᱟᱜᱼᱟ।",
    },
    {
      "hindi": "मुझे पानी चाहिए।",
      "santali": "ᱤᱧ ᱫᱟᱜ ᱥᱟᱱᱟᱹᱭ ᱢᱮᱱᱟᱜᱼᱟ।",
    },
  ];

  // ============================================================
  // DEMO LESSON
  // ============================================================

  static const Map<String, dynamic> lesson = {
    "title": "Learning About Trees",
    "class": "Grade 1",
    "subject": "Foundational Literacy",
    "language": "Hindi + Santali",
    "objective":
        "Children identify common objects around them and learn their names in their mother tongue.",
    "introduction":
        "Teacher shows a picture of a tree and asks children what they see.",
    "activity":
        "Children identify trees around the school and say the word in Hindi and Santali.",
    "assessment":
        "Ask each child to identify a tree and say one simple sentence about it.",
    "teacher_tip":
        "Use real objects and gestures to help children understand new vocabulary.",
  };

  // ============================================================
  // DEMO WORKSHEET
  // ============================================================

  static const Map<String, dynamic> worksheet = {
    "title": "My First Words",
    "grade": "Grade 1",
    "subject": "Foundational Literacy",
    "learning_outcome":
        "Recognize and understand basic words.",
    "questions": [
      "Circle the picture of a tree.",
      "Match the word with the correct picture.",
      "Say the name of the object shown by the teacher.",
      "Complete the word: P _ N.",
      "Draw a tree and write its name.",
    ],
  };

  // ============================================================
  // DEMO FLASHCARDS
  // ============================================================

  static final List<Map<String, String>> flashcards = [
    {
      "word": "Tree",
      "hindi": "पेड़",
      "santali": "ᱫᱟᱨᱮ",
      "visual": "A large green tree",
    },
    {
      "word": "Water",
      "hindi": "पानी",
      "santali": "ᱫᱟᱜ",
      "visual": "A glass of water",
    },
    {
      "word": "Sun",
      "hindi": "सूरज",
      "santali": "ᱥᱤᱧ",
      "visual": "Bright sun in the sky",
    },
    {
      "word": "House",
      "hindi": "घर",
      "santali": "ᱚᱲᱟᱜ",
      "visual": "A small village house",
    },
    {
      "word": "Book",
      "hindi": "किताब",
      "santali": "ᱯᱩᱛᱷᱤ",
      "visual": "A school book",
    },
    {
      "word": "Flower",
      "hindi": "फूल",
      "santali": "ᱵᱟᱦᱟ",
      "visual": "A colourful flower",
    },
  ];

  // ============================================================
  // CLASSROOM DEMO
  // ============================================================

  static final List<Map<String, String>> classroomConversation = [
    {
      "speaker": "Teacher",
      "language": "Hindi",
      "text": "सब बच्चे बैठ जाओ।",
    },
    {
      "speaker": "AI",
      "language": "Santali",
      "text": "ᱡᱚᱛᱚ ᱦᱚᱲ ᱠᱚ ᱫᱩᱵ ᱢᱮ।",
    },
    {
      "speaker": "Teacher",
      "language": "Hindi",
      "text": "तुम्हारा नाम क्या है?",
    },
    {
      "speaker": "AI",
      "language": "Santali",
      "text": "ᱟᱢᱟᱜ ᱧᱩᱛ ᱪᱮᱫ ᱠᱟᱱᱟ?",
    },
  ];

  // ============================================================
  // DEMO STUDENTS
  // ============================================================

  static final List<Map<String, dynamic>> students = [
    {
      "name": "Rani",
      "grade": "Grade 1",
      "language": "Santali",
      "progress": 82,
    },
    {
      "name": "Birsa",
      "grade": "Grade 1",
      "language": "Santali",
      "progress": 76,
    },
    {
      "name": "Suman",
      "grade": "Grade 1",
      "language": "Santali",
      "progress": 91,
    },
    {
      "name": "Maya",
      "grade": "Grade 1",
      "language": "Santali",
      "progress": 68,
    },
  ];

  // ============================================================
  // DEMO STATISTICS
  // ============================================================

  static const Map<String, dynamic> dashboardStats = {
    "students": 32,
    "lessons": 18,
    "worksheets": 27,
    "flashcards": 42,
  };

  // ============================================================
  // OFFLINE CONTENT
  // ============================================================

  static final List<Map<String, String>> offlineLessons = [
    {
      "title": "Basic Words",
      "grade": "Grade 1",
      "language": "Santali",
      "size": "1.2 MB",
    },
    {
      "title": "Numbers 1–10",
      "grade": "Grade 1",
      "language": "Santali",
      "size": "0.8 MB",
    },
    {
      "title": "Plants Around Us",
      "grade": "Grade 2",
      "language": "Santali",
      "size": "1.5 MB",
    },
    {
      "title": "My Family",
      "grade": "Grade 1",
      "language": "Santali",
      "size": "0.9 MB",
    },
  ];

  // ============================================================
  // DEMO SCHEMES
  // ============================================================

  static final List<Map<String, String>> schemes = [
    {
      "name": "PM POSHAN",
      "description": "Nutritious meals for school children.",
      "eligibility": "Primary and upper-primary students",
    },
    {
      "name": "Samagra Shiksha",
      "description": "Support for school education and learning.",
      "eligibility": "School students",
    },
    {
      "name": "Scholarship Support",
      "description": "Educational financial assistance.",
      "eligibility": "Eligible school students",
    },
  ];

  // ============================================================
  // DEMO FALLBACK TRANSLATION HELPER
  // ============================================================

  static String getDemoTranslation(String text) {
    final normalized = text.trim();

    for (final item in translations) {
      if (item['hindi'] == normalized) {
        return item['santali'] ?? '';
      }
    }

    return ' Demo translation unavailable for this sentence.';
  }
}
