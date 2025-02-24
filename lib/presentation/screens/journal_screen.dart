import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/theme.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/background_decorator_widget.dart';
import '../../app/routes.dart';
import 'dart:ui' as ui;

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _journalController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _moodValue = 5.0;
  bool _isSubmitting = false;
  bool _isAutoAnalyzing = true;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  final List<String> _moodEmojis = [
    '😢', '😔', '😕', '😐', '🙂', '😊', '😄', '🥳', '⭐', '✨',
  ];

  final List<String> _randomPrompts = [
    "What made you smile today?",
    "Share a tiny victory from your day...",
    "What's something you're looking forward to?",
    "Describe your day in three words...",
    "What's something new you learned today?",
    "What made you feel proud recently?",
    "Share a moment of gratitude...",
    "What's something that challenged you today?",
    "What would you tell your future self about today?",
    "Describe a small act of kindness you witnessed...",
  ];

  late String _currentPrompt;

  @override
  void initState() {
    super.initState();
    _currentPrompt = _getRandomPrompt();
  }

  String _getRandomPrompt() {
    _randomPrompts.shuffle();
    return _randomPrompts.first;
  }

  String _getMoodEmoji() {
    int index = (_moodValue - 1).round();
    index = index.clamp(0, _moodEmojis.length - 1);
    return _moodEmojis[index];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final horizontalPadding = isDesktop ? screenWidth * 0.1 : screenWidth * 0.05;

    return BackgroundDecorator(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: AppTheme.kTextBrown,
                      size: 28,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/logos/sereni_logo.png',
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppTheme.kPrimaryGreen.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/logos/sereni_logo.png',
                      height: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Mindful Journey',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.kTextBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: AppTheme.kPrimaryGreen),
                title: const Text('Home'),
                onTap: () => Navigator.pushReplacementNamed(context, RouteManager.home),
              ),
              ListTile(
                leading: const Icon(Icons.edit_note, color: AppTheme.kPrimaryGreen),
                title: const Text('Journal'),
                selected: true,
                selectedTileColor: AppTheme.kPrimaryGreen.withOpacity(0.1),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.insights, color: AppTheme.kPrimaryGreen),
                title: const Text('Insights'),
                onTap: () => Navigator.pushReplacementNamed(context, RouteManager.insights),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline, color: AppTheme.kPrimaryGreen),
                title: const Text('Profile'),
                onTap: () => Navigator.pushReplacementNamed(context, RouteManager.profile),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.kAccentBrown),
                title: const Text('Logout'),
                onTap: () {
                  // Implement logout logic
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppTheme.kSpacing3x,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppTheme.kSpacing3x),
                  _buildMoodSelector(),
                  const SizedBox(height: AppTheme.kSpacing4x),
                  Text(
                    "Time to reflect on your journey ✨",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.kTextBrown,
                    ),
                  ),
                  const SizedBox(height: AppTheme.kSpacing),
                  Text(
                    DateFormat('EEEE, MMMM d, h:mm a').format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.kGray600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: AppTheme.kSpacing2x),
                  _buildJournalEditor(),
                  const SizedBox(height: AppTheme.kSpacing3x),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    String greeting;
    if (now.hour < 12) {
      greeting = "Good morning, sunshine! ☀️";
    } else if (now.hour < 17) {
      greeting = "Good afternoon, friend! 🌤️";
    } else {
      greeting = "Good evening, starlight! 🌙";
    }

    return Text(
      greeting,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
        color: AppTheme.kTextBrown,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kPrimaryGreen.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.kPrimaryGreen.withOpacity(0.8),
                    inactiveTrackColor: AppTheme.kGray300.withOpacity(0.3),
                    overlayColor: AppTheme.kPrimaryGreen.withOpacity(0.15),
                    trackHeight: 8.0,
                    thumbShape: EmojiSliderThumbShape(
                      emoji: _getMoodEmoji(),
                    ),
                  ),
                  child: Slider(
                    value: _moodValue,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (value) {
                      setState(() {
                        _moodValue = value;
                      });
                    },
                  ),
                ),
              ),
              Switch(
                value: _isAutoAnalyzing,
                onChanged: (value) {
                  setState(() {
                    _isAutoAnalyzing = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Mood auto-analysis enabled' : 'Mood auto-analysis disabled'
                      ),
                      backgroundColor: AppTheme.kPrimaryGreen,
                    ),
                  );
                },
                activeColor: AppTheme.kAccentBrown,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextEditorControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.kGray300.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.format_bold,
              color: _isBold ? AppTheme.kPrimaryGreen : AppTheme.kGray600,
            ),
            onPressed: () => setState(() => _isBold = !_isBold),
          ),
          IconButton(
            icon: Icon(
              Icons.format_italic,
              color: _isItalic ? AppTheme.kPrimaryGreen : AppTheme.kGray600,
            ),
            onPressed: () => setState(() => _isItalic = !_isItalic),
          ),
          IconButton(
            icon: Icon(
              Icons.format_underline,
              color: _isUnderline ? AppTheme.kPrimaryGreen : AppTheme.kGray600,
            ),
            onPressed: () => setState(() => _isUnderline = !_isUnderline),
          ),
          const VerticalDivider(width: 16),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: () {
              final text = _journalController.text;
              final selection = _journalController.selection;
              final newText = '• ${text.substring(selection.start, selection.end)}\n';
              _journalController.text = text.replaceRange(selection.start, selection.end, newText);
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_quote),
            onPressed: () {
              final text = _journalController.text;
              final selection = _journalController.selection;
              final newText = '> ${text.substring(selection.start, selection.end)}';
              _journalController.text = text.replaceRange(selection.start, selection.end, newText);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kPrimaryGreen.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.kSpacing2x),
            child: Row(
              children: [
                const Text(
                  '✨ Journal Entry',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('New Prompt'),
                  onPressed: () {
                    setState(() {
                      _currentPrompt = _getRandomPrompt();
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.kSpacing2x),
            child: Text(
              _currentPrompt,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.kGray600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          _buildTextEditorControls(),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.kRadiusMedium),
                bottomRight: Radius.circular(AppTheme.kRadiusMedium),
              ),
            ),
            child: TextField(
              controller: _journalController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Let your thoughts flow freely...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppTheme.kSpacing2x),
                fillColor: Colors.white.withOpacity(0.9),
                filled: true,
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
              ),
              onChanged: _isAutoAnalyzing ? _analyzeEntryMood : null,
            ),
            
            // continuation
            ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.kSpacing2x),
            child: _buildWordCount(),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCount() {
    int wordCount = _journalController.text.split(' ').where((word) => word.isNotEmpty).length;
    return Text(
      '$wordCount words',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppTheme.kGray600,
      ),
    );
  }

  void _analyzeEntryMood(String text) {
    if (text.length < 10) return;

    final positiveWords = ['happy', 'joy', 'great', 'awesome', 'wonderful', 'love', 'excited'];
    final negativeWords = ['sad', 'angry', 'upset', 'frustrated', 'worried', 'anxious', 'tired'];

    int positiveCount = 0;
    int negativeCount = 0;

    final words = text.toLowerCase().split(' ');
    for (var word in words) {
      if (positiveWords.contains(word)) positiveCount++;
      if (negativeWords.contains(word)) negativeCount--;
    }

    if (positiveCount + negativeCount != 0) {
      double newMood = 5.0;
      newMood += positiveCount * 0.5;
      newMood += negativeCount * 0.5;
      newMood = newMood.clamp(1.0, 10.0);

      setState(() {
        _moodValue = newMood;
      });
    }
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kAccentBrown.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.kAccentBrown,
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.kSpacing2x,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.kWhite),
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Save this moment',
                    style: TextStyle(
                      color: AppTheme.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '✨',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_journalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your thoughts matter - write something before saving! 💭'),
          backgroundColor: AppTheme.kWarningYellow,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement journal entry saving logic here
      
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entry saved! Keep shining ${_getMoodEmoji()}'),
            backgroundColor: AppTheme.kSuccessGreen,
          ),
        );
        _journalController.clear();
        setState(() {
          _moodValue = 5.0;
          _currentPrompt = _getRandomPrompt();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oops! Something went wrong. Try again? 🤔'),
            backgroundColor: AppTheme.kErrorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }
}

class EmojiSliderThumbShape extends SliderComponentShape {
  final String emoji;

  const EmojiSliderThumbShape({required this.emoji});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(30, 30);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required ui.TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final canvas = context.canvas;
    
    // Draw background circle with shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(center, 16, shadowPaint);
    
    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 15, backgroundPaint);
    
    // Paint emoji
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: const TextStyle(
          fontSize: 20,
          height: 1,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    
    textPainter.paint(canvas, offset);
  }
}