String twoDigits(int n) => n.toString().padLeft(2, '0');

String formatDate(DateTime date) {
  return "${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}";
}
