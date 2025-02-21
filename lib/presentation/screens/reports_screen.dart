import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sereni_app/app/theme/theme.dart';
import 'package:sereni_app/app/routes.dart';
import 'package:sereni_app/presentation/widgets/navigation_widget.dart';

// Models
class ReportEntry {
  final DateTime timestamp;
  final String type; // 'mood', 'chat', or 'journal'
  final String content;
  final String? moodScore; // Only for mood entries

  ReportEntry({
    required this.timestamp,
    required this.type,
    required this.content,
    this.moodScore,
  });
}

// Report Screen Widget
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
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
                Text(
                  'Happy',
                  style: Theme.of(context).textTheme.titleLarge,
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
        return _buildMoodCard(/* Mood data here */);
      },
    );
  }

 Widget _buildChatsCard() {
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
                Text(
                  'tired',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '6/10',
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
              'Feeling  anxious',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

//implementation for journal tab

Widget _buildJournalsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return _buildMoodCard(/* Mood data here */);
      },
    );
  }

 Widget _buildJournalsCard() {
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
                Text(
                  'sad',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '5/10',
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
              'Feeling sad ,dont know why.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }





  // Similar implementations for Chats and Journals tabs...

  void _handlePrint() {
    // Implement print functionality
  }

  void _handleShare() {
    // Implement share functionality
  }
}