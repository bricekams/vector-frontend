extension StringExtension on String {
  String trimOut () {
    return trimLeft().trimRight();
  }
}