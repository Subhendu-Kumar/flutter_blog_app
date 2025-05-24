String calculateReadingTime(String text) {
  const int wordsPerMinute = 200;
  final int wordCount = text.split(RegExp(r'\s+')).length;
  final double minutes = wordCount / wordsPerMinute;

  if (minutes < 1) {
    return 'Less than a minute';
  } else {
    final int roundedMinutes = minutes.ceil();
    return '$roundedMinutes minute${roundedMinutes > 1 ? 's' : ''}';
  }
}
