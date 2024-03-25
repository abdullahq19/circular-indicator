import 'package:flutter/material.dart';
import 'package:flutter_progress_indicator/circular_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularIndicator(
          indicatorType: IndicatorType.staticProgress,
          progressValue: 665,
          maxValue: 1000,
          size: 100,
          showBackground: true,
          strokeWidth: 5,
          duration: Duration(seconds: 3),
        ),
      ),
    );
  }
}
