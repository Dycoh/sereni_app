// lib/widgets/insights/insights_carousel.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../app/theme/theme.dart';

class InsightsCarousel extends StatelessWidget {
  final List<InsightCard> insights;

  const InsightsCarousel({
    super.key,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AI Insights',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: AppTheme.kSpacing),
            const Text('🥰', style: TextStyle(fontSize: 24)),
          ],
        ),
        const SizedBox(height: AppTheme.kSpacing2x),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.9,
            enableInfiniteScroll: false,
            scrollDirection: Axis.vertical,
          ),
          items: insights,
        ),
      ],
    );
  }
}

class InsightCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const InsightCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.kSpacing),
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.kPrimaryGreen),
              const SizedBox(width: AppTheme.kSpacing),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.kSpacing),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}