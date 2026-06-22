class AppDateUtils {
  static String formatYear(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    return date.substring(0, 4);
  }

  static String formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parts = date.split('-');
    if (parts.length < 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
