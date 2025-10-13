import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF26C6DA);
const Color textColor = Colors.black87;

/// A large, bold header for a major section of the form.
class FormSectionHeader extends StatelessWidget {
  final String title;
  const FormSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: textColor,
        ),
      ),
    );
  }
}

/// A smaller sub-header, often with an icon, for a specific group of fields.
class FormSubHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? iconPath;

  const FormSubHeader(this.title, {super.key, this.icon, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.red.shade400, size: 20),
            const SizedBox(width: 8)
          ],
          if (iconPath != null) ...[
            Image.asset(iconPath!, width: 24, height: 24),
            const SizedBox(width: 8)
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A reusable InputDecoration for TextFormField widgets.
class FormInputDecoration extends InputDecoration {
  const FormInputDecoration({super.labelText})
      : super(
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          labelStyle: const TextStyle(color: textColor),
        );
}

/// A simple checkbox widget paired with a title.
class FormCheckbox extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const FormCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: primaryColor,
        ),
        Text(title),
      ],
    );
  }
}

/// A widget for a group of radio buttons under a common title.
class FormRadioGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final IconData? icon;
  final String? iconPath;

  const FormRadioGroup({
    super.key,
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.icon,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSubHeader(title, icon: icon, iconPath: iconPath),
        Wrap(
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: const TextStyle(fontSize: 14),
              ),
              value: option,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: primaryColor,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
