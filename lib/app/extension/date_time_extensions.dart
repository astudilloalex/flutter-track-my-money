extension DateTimeExtensions on DateTime {
  String toShortDateString() {
    return "$day/$month/$year";
  }

  DateTime get lastDayOfMonth {
    // If it's not December, move to the next month; otherwise, roll over to January of the next year.
    final DateTime firstDayNextMonth =
        (month < 12) ? DateTime(year, month + 1) : DateTime(year + 1);

    // Subtract one day to get the last day of the current month.
    return firstDayNextMonth.subtract(const Duration(days: 1));
  }
}
