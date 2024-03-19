import 'dart:math';
import 'package:flutter/material.dart';

// Enum for specifying the type of indicator
enum IndicatorType {
  loading, // For continuously loading indicators
  staticProgress, // For static progress indicators
}

// Enum for specifying the direction of progress
enum ProgressDirection {
  clockwise,
  counterClockwise;
}


// Custom widget for displaying a progress indicator
class CircularIndicator extends StatefulWidget {
  // Properties
  final double size; // Size of the indicator
  final Color color; // Color of the indicator
  final Gradient? gradient; // Gradient of the indicator
  final Gradient? backgroundGradient; // Background gradient of the indicator
  final Color backgroundColor; // Background color of the indicator
  final double strokeWidth; // Stroke width of the indicator
  final StrokeCap strokeCap; // Stroke cap style of the indicator
  final Duration duration; // Duration of the animation
  final TextStyle progressTextStyle; // Text style for displaying progress
  final IndicatorType indicatorType; // Type of the indicator
  final ProgressDirection direction; // Direction of progress
  final bool showBackground; // Whether to show the background of the indicator
  final double progressValue; // Current progress value
  final double maxValue; // Maximum value of progress
  final Curve curve; // Curve for animation
  final void Function()? onTap; // Callback function for tap event

  // Constructor
  const CircularIndicator({
    Key? key,
    required this.indicatorType,
    this.size = 100,
    this.onTap,
    this.progressValue = 0.0,
    this.maxValue = 100,
    this.color = Colors.blue,
    this.showBackground = false,
    this.strokeWidth = 3,
    this.direction = ProgressDirection.clockwise,
    this.curve = Curves.easeInOutCubic,
    this.backgroundColor = const Color.fromARGB(255, 204, 204, 204),
    this.duration = const Duration(seconds: 2),
    this.gradient,
    this.backgroundGradient,
    this.strokeCap = StrokeCap.round,
    this.progressTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  }) : super(key: key);

  @override
  State<CircularIndicator> createState() =>
      _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Initialize Animation Tween
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.indicatorType == IndicatorType.loading
          ? 1.0
          : widget.progressValue /
              widget
                  .maxValue, // Converting progressValue into Animation Tween value so it can animate to the given value
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
      ),
    )..addListener(() {
        setState(() {}); // Set state for widget rebuild on state change
      });

    // Toggle animations between two states of IndicatorType
    if (widget.indicatorType == IndicatorType.loading) {
      _animationController
          .repeat(); // Repeating Animation if IndicatorType.loading
    } else {
      _animationController
          .forward(); // Static Animation if IndicatorType.staticProgress
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose Animation Controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(); // Invoke Callback if onTap is not null
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Warning: onTap callback not provided'))); // Show a SnackBar if onTap Callback is not provided
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: CircularProgressPainter(
                    value: _animation.value,
                    color: widget.color,
                    gradient: widget.gradient,
                    backgroundGradient: widget.backgroundGradient,
                    backgroundColor: widget.backgroundColor,
                    strokeWidth: widget.strokeWidth,
                    strokeCap: widget.strokeCap,
                    direction: widget.direction,
                    showBackground: widget.showBackground,
                  ),
                ),
                Visibility(
                  visible: widget.indicatorType == IndicatorType.staticProgress,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${(_animation.value * widget.maxValue).toStringAsFixed(0)}%', // Setting current value of progressValue by getting live value from animation tween
                      style: widget.progressTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// CustomPainter

class CircularProgressPainter extends CustomPainter {
  final double value; // The current value of the progress (0.0 to 1.0)
  final Color color; // The color of the progress indicator
  final Gradient? gradient; // Optional gradient for the progress indicator
  final Gradient? backgroundGradient; // Optional gradient for the background
  final Color backgroundColor; // Background color
  final double strokeWidth; // Width of the progress indicator
  final StrokeCap strokeCap; // Shape of the progress indicator ends
  final bool showBackground; // Whether to show the background
  final ProgressDirection direction; // Direction of the progress indicator

  CircularProgressPainter({
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
        -pi / 2,
        2 * pi * value,
        false,
        indicatorPaint,
      );
    } else {
      // Draw the progress indicator in a counter-clockwise direction
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        -2 * pi * value,
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
      -pi / 2,
      2 * pi,
      false,
      backgroundPaint,
    );
  }

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
