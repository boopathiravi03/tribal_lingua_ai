import 'package:flutter/material.dart';

import 'screens/lesson/lesson_generator_screen.dart';
import 'screens/worksheet/worksheet_screen.dart';
import 'screens/flashcards/flashcard_screen.dart';
import 'screens/classroom/classroom_mode_screen.dart';
import 'screens/offline/offline_content_screen.dart';
import 'screens/voice/voice_translation_screen.dart';
import 'services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const TribalLinguaApp());
}

class TribalLinguaApp extends StatelessWidget {
  const TribalLinguaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF087F73);
    const lightBackground = Color(0xFFF4F8F6);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tribal Lingua AI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: lightBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primaryGreen,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool backendOnline = false;
  bool checkingBackend = true;

  @override
  void initState() {
    super.initState();
    _checkBackend();
  }

  Future<void> _checkBackend() async {
    setState(() {
      checkingBackend = true;
    });

    final result = await ApiService.checkHealth();

    if (!mounted) return;

    setState(() {
      backendOnline = result;
      checkingBackend = false;
    });
  }

  void _open(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _checkBackend,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 275,
              pinned: true,
              backgroundColor: const Color(0xFF087F73),
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF075E54),
                        Color(0xFF087F73),
                        Color(0xFF159D8D),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        22,
                        65,
                        22,
                        20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.translate_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'TRIBAL LINGUA AI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            'Every child learns\nin their mother tongue.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'AI-powered vernacular pedagogy for foundational education.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Refresh backend',
                  onPressed: _checkBackend,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BackendStatusCard(
                      online: backendOnline,
                      checking: checkingBackend,
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE6C96A),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.science_rounded,
                            color: Color(0xFF8A6800),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Prototype Demo Mode • Sample classroom data enabled',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6F5700),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Teacher Toolkit',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF18302C),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'AI tools for mother-tongue classroom teaching',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _ToolCard(
                      icon: Icons.record_voice_over_rounded,
                      title: 'Live Voice Translation',
                      subtitle: 'Hindi ↔ Santali voice assistant',
                      badge: 'LIVE',
                      onTap: () {
                        _open(const VoiceTranslationScreen());
                      },
                    ),

                    const SizedBox(height: 12),

                    _ToolCard(
                      icon: Icons.auto_stories_rounded,
                      title: 'AI Lesson Generator',
                      subtitle: 'Generate bilingual FLN lesson content',
                      onTap: () {
                        _open(const LessonGeneratorScreen());
                      },
                    ),

                    const SizedBox(height: 12),

                    _ToolCard(
                      icon: Icons.assignment_rounded,
                      title: 'Worksheet Generator',
                      subtitle: 'Create NIPUN-aligned bilingual worksheets',
                      onTap: () {
                        _open(const WorksheetScreen());
                      },
                    ),

                    const SizedBox(height: 12),

                    _ToolCard(
                      icon: Icons.style_rounded,
                      title: 'Visual Flashcards',
                      subtitle: 'AI-generated vocabulary and learning cards',
                      onTap: () {
                        _open(const FlashcardScreen());
                      },
                    ),

                    const SizedBox(height: 12),

                    _ToolCard(
                      icon: Icons.groups_rounded,
                      title: 'Classroom Mode',
                      subtitle: 'Teacher ↔ student real-time interaction',
                      onTap: () {
                        _open(const ClassroomModeScreen());
                      },
                    ),

                    const SizedBox(height: 12),

                    _ToolCard(
                      icon: Icons.cloud_download_rounded,
                      title: 'Offline Learning',
                      subtitle: 'Saved lessons for low-connectivity areas',
                      onTap: () {
                        _open(const OfflineContentScreen());
                      },
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Prototype Architecture',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF18302C),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _ArchitectureCard(),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F3EF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag_rounded,
                                color: Color(0xFF087F73),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'SIH Prototype',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF075E54),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Hindi → Santali translation • AI pedagogy • '
                            'voice interaction • worksheets • flashcards • '
                            'offline learning',
                            style: TextStyle(
                              height: 1.5,
                              color: Color(0xFF34504B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BACKEND STATUS
// ============================================================

class _BackendStatusCard extends StatelessWidget {
  final bool online;
  final bool checking;

  const _BackendStatusCard({
    required this.online,
    required this.checking,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = checking
        ? Colors.orange
        : online
            ? Colors.green
            : Colors.red;

    final statusText = checking
        ? 'Checking AI backend...'
        : online
            ? 'AI backend connected'
            : 'Backend unavailable';

    final description = checking
        ? 'Connecting to Local FastAPI service'
        : online
            ? 'Local FastAPI • Groq AI'
            : 'Pull down to retry the connection';

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (online)
            const Icon(
              Icons.cloud_done_rounded,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}

// ============================================================
// TOOL CARD
// ============================================================

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F3EF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF087F73),
                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE7A3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badge!,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ARCHITECTURE CARD
// ============================================================

class _ArchitectureCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _ArchitectureRow(
            icon: Icons.phone_android_rounded,
            title: 'Flutter Android App',
            subtitle: 'Teacher / classroom interface',
          ),
          _Line(),
          _ArchitectureRow(
            icon: Icons.computer_rounded,
            title: 'FastAPI Local Backend',
            subtitle: 'Local API and orchestration',
          ),
          _Line(),
          _ArchitectureRow(
            icon: Icons.psychology_rounded,
            title: 'Groq AI',
            subtitle: 'Translation + pedagogy generation',
          ),
          _Line(),
          _ArchitectureRow(
            icon: Icons.language_rounded,
            title: 'Hindi ↔ Santali',
            subtitle: 'Vernacular primary education',
          ),
        ],
      ),
    );
  }
}

class _ArchitectureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ArchitectureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F3EF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF087F73),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 21,
        top: 6,
        bottom: 6,
      ),
      width: 1,
      height: 22,
      color: Colors.black12,
    );
  }
}
