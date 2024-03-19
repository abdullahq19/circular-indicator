import 'package:flutter/material.dart';
import 'package:flutter_progress_indicator/circular_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      body: Center(
        child: CircularIndicator(
          indicatorType: IndicatorType.staticProgress,
          progressValue: 320,
          maxValue: 500,
          showBackground: true,
          color: Colors.indigo,
          size: 200,
          strokeWidth: 10,
          duration: Duration(seconds: 4),
          progressTextStyle: TextStyle(color: Colors.indigo,fontSize: 20,fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}