import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/theme/theme.dart';
import '../widgets/navigation_widget.dart';
import '../../app/routes.dart';
 // Add this import for the correct TextDirection
import 'dart:ui' as ui;


class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _journalController = TextEditingController();
  double _moodValue = 5.0;
  bool _isSubmitting = false;
  bool _isAutoAnalyzing = true;

  // Mood emojis from negative to positive
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
    return CustomScaffold(
      currentRoute: RouteManager.journal,
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Image.asset(
                  'assets/logos/sereni_logo.png',
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
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
        color: AppTheme.kPrimaryGreen.withValues(alpha: 26),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.kPrimaryGreen,
                    inactiveTrackColor: AppTheme.kGray300,
                    overlayColor: AppTheme.kPrimaryGreen.withValues(alpha: 26),
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

  Widget _buildJournalEditor() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: AppTheme.kWhite,
        borderRadius: BorderRadius.circular(AppTheme.kRadiusMedium),
        boxShadow: AppTheme.kShadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨ Journal Entry'),
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
          const SizedBox(height: AppTheme.kSpacing),
          Text(
            _currentPrompt,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.kGray600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppTheme.kSpacing2x),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: AppTheme.kBackgroundColor.withValues(alpha: 128),
              borderRadius: BorderRadius.circular(AppTheme.kRadiusSmall),
            ),
            child: TextField(
              controller: _journalController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'Let your thoughts flow freely...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(AppTheme.kSpacing2x),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: _isAutoAnalyzing ? _analyzeEntryMood : null,
            ),
          ),
          const SizedBox(height: AppTheme.kSpacing),
          _buildWordCount(),
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
    return SizedBox(
      width: double.infinity,
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
        ),
        child: _isSubmitting
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.kWhite),
              )
            : const Text(
                'Save this moment ✨',
                style: TextStyle(
                  color: AppTheme.kWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
    required SliderThemeData sliderTheme,
    required ui.TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    
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