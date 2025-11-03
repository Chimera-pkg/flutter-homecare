import 'package:flutter/material.dart';

/// A reusable button with a customizable gradient background.
///
/// This widget wraps an [ElevatedButton] in a [Container] with a
/// [BoxDecoration] to apply a gradient. The button style is set
/// to be transparent to let the gradient show through.
class GradientButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// The gradient to apply to the button's background.
  ///
  /// If null, a default gradient is used.
  final Gradient? gradient;

  /// The height of the button.
  ///
  /// Defaults to 50.0.
  final double height;

  /// The width of the button.
  ///
  /// Defaults to [double.infinity] to fill the available width.
  final double? width;

  /// The border radius for the button's corners.
  ///
  /// Defaults to `BorderRadius.circular(12)`.
  final BorderRadiusGeometry? borderRadius;

  /// The color of the text.
  ///
  /// Defaults to [Colors.white].
  final Color textColor;

  /// The style of the text.
  ///
  /// If null, a default style is used (white, bold, 16.0).
  final TextStyle? textStyle;

  /// The default gradient used if [gradient] is not specified.
  static const Gradient defaultGradient = LinearGradient(
    colors: [
      Color(0xFF9DCEFF),
      Color(0xFF35C5CF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.height = 50.0,
    this.width = double.infinity,
    this.borderRadius,
    this.textColor = Colors.white,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Use the provided border radius or the default
    final br = borderRadius ?? BorderRadius.circular(12);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Use the provided gradient or the default
        gradient: gradient ?? defaultGradient,
        borderRadius: br,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: br),
        ),
        child: Text(
          text,
          // Use the provided text style or the default
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
      ),
    );
  }
}
