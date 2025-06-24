extension StringExtension on String {
  String trimOut () {
    return trimLeft().trimRight();
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}