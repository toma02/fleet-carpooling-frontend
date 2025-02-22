import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';

class MyCustomSlider extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final String time;
  final ValueChanged<double> onChanged;

  const MyCustomSlider({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
    required this.time,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyCustomSliderState createState() => _MyCustomSliderState();
}

class _MyCustomSliderState extends State<MyCustomSlider> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.buttonColor,
              inactiveTrackColor: AppColors.backgroundColor,
              overlayColor: Colors.blue.withOpacity(0.2),
              thumbShape: _MyCustomThumbShape(widget.time),
              trackHeight: 2.0,
            ),
            child: Slider(
              value: double.tryParse(_value)?.clamp(widget.min, widget.max) ??
                  widget.initialValue,
              onChanged: (newValue) {
                setState(() {
                  _value = newValue.toString();
                  widget.onChanged(newValue);
                });
              },
              min: widget.min,
              max: widget.max,
              label: _value,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyCustomThumbShape extends SliderComponentShape {
  final String time;
  final double radius;

  // ignore: unused_element
  _MyCustomThumbShape(this.time, {this.radius = 30.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(50, 30);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    required bool isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = AppColors.backgroundColor
      ..style = PaintingStyle.fill;

    final RRect thumbRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: getPreferredSize(false, isDiscrete).width,
        height: getPreferredSize(false, isDiscrete).height,
      ),
      Radius.circular(radius),
    );

    canvas.drawRRect(thumbRRect, paint);

    final TextSpan span = TextSpan(
      text: time,
      style: const TextStyle(
        color: AppColors.mainTextColor,
        fontSize: 12.0,
      ),
    );
    final TextPainter textPainter = TextPainter(
      text: span,
      textDirection: textDirection!,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }
}
