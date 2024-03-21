import 'package:flutter/material.dart';
import 'package:flutter_progress_indicator/circular_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.blue.shade100.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularIndicator(
                      indicatorType: IndicatorType.staticProgress,
                      progressValue: 23,
                      maxValue: 100,
                      showBackground: true,
                      backgroundColor: Colors.purple.shade100,
                      color: Colors.purple,
                      strokeWidth: 10,
                      duration: const Duration(seconds: 4),
                      progressTextStyle: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularIndicator(
                      indicatorType: IndicatorType.staticProgress,
                      progressValue: 48,
                      maxValue: 100,
                      showBackground: true,
                      backgroundColor: Colors.blue.shade100,
                      color: Colors.blue,
                      strokeWidth: 10,
                      duration: const Duration(seconds: 4),
                      progressTextStyle: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularIndicator(
                      indicatorType: IndicatorType.staticProgress,
                      progressValue: 69,
                      maxValue: 100,
                      showBackground: true,
                      backgroundColor: Colors.green.shade100,
                      color: Colors.green,
                      strokeWidth: 10,
                      duration: const Duration(seconds: 4),
                      progressTextStyle: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularIndicator(
                      indicatorType: IndicatorType.staticProgress,
                      progressValue: 83,
                      maxValue: 100,
                      showBackground: true,
                      backgroundColor: Colors.red.shade100,
                      color: Colors.red,
                      strokeWidth: 10,
                      duration: const Duration(seconds: 4),
                      progressTextStyle: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
