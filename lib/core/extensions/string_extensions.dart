// In lib/core/extensions/string_extensions.dart

extension StringTitleCase on String {
  String toTitleCase() {
    if (isEmpty) {
      return "";
    }

    // Split by whitespace, handling multiple spaces and trimming
    final words = trim().split(RegExp(r'\s+'));

    if (words.isEmpty) {
      return "";
    }

    return words.map((word) {
      if (word.isEmpty) {
        return "";
      }
      // Capitalize first letter, lower case the rest
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
