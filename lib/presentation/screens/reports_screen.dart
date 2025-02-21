import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:sereni_app/app/theme/theme.dart';
import 'package:sereni_app/app/routes.dart';
import 'package:sereni_app/presentation/widgets/navigation_widget.dart';



// Models
class ReportEntry {
  final DateTime timestamp;
  final String type; // 'mood', 'chat', or 'journal'
  final String content;
  final String? moodScore; // Only for mood entries
  final String? moodEmoji; // Added for mood entries

  ReportEntry({
    required this.timestamp,
    required this.type,
    required this.content,
    this.moodScore,
    this.moodEmoji,
  });
}

// Helper function to get mood emoji
String getMoodEmoji(String mood, String score) {
  // Convert score to number for comparison
  double scoreNum = double.parse(score.split('/')[0]);
  
  switch (mood.toLowerCase()) {
    case 'happy':
      return scoreNum >= 8 ? '😄' : '🙂';
    case 'sad':
      return scoreNum >= 5 ? '😔' : '😢';
    case 'angry':
      return scoreNum >= 5 ? '😠' : '😡';
    case 'anxious':
      return scoreNum >= 5 ? '😰' : '😨';
    case 'calm':
      return scoreNum >= 8 ? '😌' : '😊';
    default:
      return '😐';
  }
}

// Report Screen Widget
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  final List<String> _timeFilters = ['All', 'Today', 'Week', 'Month'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      currentRoute: '/reports',
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterChips(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMoodsTab(),
                _buildChatsTab(),
                _buildJournalsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reports',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.kTextGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: () => _handlePrint(),
                color: AppTheme.kAccentBrown,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _handleShare(),
                color: AppTheme.kAccentBrown,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _timeFilters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(_timeFilters[index]),
              selected: _selectedFilter == _timeFilters[index],
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = _timeFilters[index];
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.kLightGreenContainer,
              labelStyle: TextStyle(
                color: _selectedFilter == _timeFilters[index]
                    ? AppTheme.kPrimaryGreen
                    : AppTheme.kTextGreen,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.kPrimaryGreen,
        unselectedLabelColor: AppTheme.kTextGreen,
        indicatorColor: AppTheme.kPrimaryGreen,
        tabs: const [
          Tab(text: 'Moods'),
          Tab(text: 'Chats'),
          Tab(text: 'Journals'),
        ],
      ),
    );
  }

  Widget _buildMoodsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return _buildMoodCard(/* Mood data here */);
      },
    );
  }


  Widget _buildMoodCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      getMoodEmoji('Happy', '8/10'), // Add emoji
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Happy',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Text(
                  '8/10',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.kPrimaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM dd, yyyy - hh:mm a').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Feeling great after completing my daily meditation session.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

//implementation for chat tab

 Widget _buildChatsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return _buildChatCard();
      },
    );
  }

  Widget _buildChatCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.kLightGreenContainer,
                  child: Icon(Icons.chat_bubble_outline, color: AppTheme.kPrimaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chat with AI Assistant',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a').format(DateTime.now()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Q: How can I improve my meditation practice?\n'
              'A: Start with short sessions, focus on your breath, and gradually increase duration...',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Journal tab implementation
  Widget _buildJournalsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return _buildJournalCard();
      },
    );
  }

  Widget _buildJournalCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.book_outlined, color: AppTheme.kPrimaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Reflection',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a').format(DateTime.now()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Today was a productive day. I managed to complete my meditation session and made progress on my personal project...',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Print functionality
  Future<void> _handlePrint() async {
    final pdf = pw.Document();

    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Wellness Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Generated on ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 30),
              // Add more sections for moods, chats, and journals...
            ],
          );
        },
      ),
    );

    // Print the document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Share functionality
  Future<void> _handleShare() async {
    try {
      // Create a temporary file
      final directory = await getTemporaryDirectory();
      final fileName = 'wellness_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.txt';
      final file = File('${directory.path}/$fileName');

      // Generate report content
      final content = StringBuffer();
      content.writeln('Wellness Report');
      content.writeln('Generated on ${DateFormat('MMM dd, yyyy').format(DateTime.now())}');
      content.writeln('\nMoods:');
      // Add mood entries...
      content.writeln('\nChats:');
      // Add chat entries...
      content.writeln('\nJournals:');
      // Add journal entries...

      // Write to file
      await file.writeAsString(content.toString());

      // Share the file
      await Share.shareFiles(
        [file.path],
        text: 'My Wellness Report',
        subject: 'Wellness Report ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
      );
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to share report: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
