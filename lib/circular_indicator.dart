import 'package:flutter/material.dart';
import 'package:flutter_progress_indicator/circular_indicator_painter.dart';

/// Enum [IndicatorType] is used to set which indicator to use

enum IndicatorType {
  loading, // For continuously loading indicator
  staticProgress /// For static progress indicator, shows the current [progressValue] provided
}

// Enum for specifying the direction of progress
enum ProgressDirection { clockwise, counterClockwise }

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
    this.backgroundColor = const Color.fromARGB(255, 187, 222, 251),
    this.duration = const Duration(seconds: 2),
    this.gradient,
    this.backgroundGradient,
    this.strokeCap = StrokeCap.round,
    this.progressTextStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w600,
    ),
  }) : super(key: key);

  @override
  State<CircularIndicator> createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.indicatorType == IndicatorType.loading
          ? 1.0
          : widget.progressValue / widget.maxValue,

      /// Converting [progressValue] into Animation Tween value so it can animate to the given value
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
      ),
    )..addListener(() {
        setState(() {}); // Set state for updating state on widget rebuild
      });

    // Toggle animations between two states of IndicatorType
    if (widget.indicatorType == IndicatorType.loading) {
      _animationController.repeat(); /// Repeating Animation if [IndicatorType.loading]
    } else {
      _animationController.forward(); /// Static Animation if [IndicatorType.staticProgress]
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Calculating [progressValue] fontSize dynamically
    double fontSize = widget.size * 0.2;
    TextStyle textStyle = widget.progressTextStyle.copyWith(fontSize: fontSize);

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(); // Invoke Callback if onTap is not null
        } else {
          print(
              'Warning: onTap Callback not provided'); // print a message if onTap Callback is not provided
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
                  painter: CircularIndicatorPainter(
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
                widget.indicatorType == IndicatorType.staticProgress
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${(_animation.value * widget.maxValue).toStringAsFixed(0)}%', /// Setting current value of [progressValue] by converting Animation Tween into current value
                          style: textStyle,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
