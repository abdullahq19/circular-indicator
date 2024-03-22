import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_progress_indicator/circular_indicator.dart';

// CustomPainter for painting a circular indicator
class CircularIndicatorPainter extends CustomPainter {
  final double value; // The current value of the progress (0.0 to 1.0)
  final Color color; // The color of the progress indicator
  final Gradient? gradient; // Optional gradient for the progress indicator
  final Gradient? backgroundGradient; // Optional gradient for the background
  final Color backgroundColor; // Background color
  final double strokeWidth; // Width of the progress indicator
  final StrokeCap strokeCap; // Shape of the progress indicator ends
  final bool showBackground; // Whether to show the background
  final ProgressDirection direction; // Direction of the progress indicator

  CircularIndicatorPainter({
    required this.value,
    required this.color,
    required this.gradient,
    required this.direction,
    required this.backgroundGradient,
    required this.showBackground,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.strokeCap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate width and height of the parent widget
    final Size(:width, :height) = size;

    // Calculate the center offset of the circle
    final center = Offset(width / 2, height / 2);

    // Calculate the radius of the circle
    final radius = min(width / 2, height / 2);

    // Paint for the progress indicator
    final indicatorPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..shader = gradient
          ?.createShader(Rect.fromCircle(center: center, radius: radius));

    // Paint for the background
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..shader = backgroundGradient
          ?.createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw the background if showBackground is true
    if (showBackground) {
      drawIndicatorBackground(canvas, size, center, radius, backgroundPaint);
    }

    // Draw the progress indicator
    drawIndicator(canvas, size, center, radius, indicatorPaint);
  }

  // Method for drawing the progress indicator
  void drawIndicator(Canvas canvas, Size size, Offset center, double radius,
      Paint indicatorPaint) {
    if (direction == ProgressDirection.clockwise) {
      // Draw the progress indicator in a clockwise direction
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        degToRadian(-90),
        degToRadian(360 * value),
        false,
        indicatorPaint,
      );
    } else {
      // Draw the progress indicator in a counter-clockwise direction
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        degToRadian(-90),
        degToRadian(-360 * value),
        false,
        indicatorPaint,
      );
    }
  }

  // Method for drawing the background
  void drawIndicatorBackground(Canvas canvas, Size size, Offset center,
      double radius, Paint backgroundPaint) {
    // Draw the background as a full circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      degToRadian(-90),
      degToRadian(360),
      false,
      backgroundPaint,
    );
  }

  double degToRadian(double deg) => deg * pi / 180;  // For converting degrees to radians

  @override
  bool shouldRepaint(CircularIndicatorPainter oldDelegate) {
    // Compare all properties of the old and new delegates
    return value != oldDelegate.value ||
        color != oldDelegate.color ||
        gradient != oldDelegate.gradient ||
        backgroundGradient != oldDelegate.backgroundGradient ||
        backgroundColor != oldDelegate.backgroundColor ||
        strokeWidth != oldDelegate.strokeWidth ||
        strokeCap != oldDelegate.strokeCap ||
        showBackground != oldDelegate.showBackground ||
        direction != oldDelegate.direction;
  }
}