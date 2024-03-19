import 'package:flutter/material.dart';
import 'package:flutter_progress_indicator/circular_indicator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

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