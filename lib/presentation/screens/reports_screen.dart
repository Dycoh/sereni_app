// reports_screen.dart
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Weekly Mood Report'),
            leading: const Icon(Icons.assessment),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to weekly report
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Monthly Progress'),
            leading: const Icon(Icons.timeline),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to monthly report
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Activity Summary'),
            leading: const Icon(Icons.bar_chart),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to activity summary
            },
          ),
        ],
      ),
    );
  }
}