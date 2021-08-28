import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  static const diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  static const nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  String removeDiacritical() => this.splitMapJoin('',
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
          ? nonDiacritics[diacritics.indexOf(char)]
          : char);

  String normalize() => this.toLowerCase().removeDiacritical();
}

TimeOfDay timeOfDayFromSlot(String slot) {
  return TimeOfDay(
      hour: int.parse(slot.substring(0, 2)),
      minute: int.parse(slot.substring(3, 5)));
}

var twoDigitsFormat = NumberFormat('00');

extension TimeOfDayExtension on TimeOfDay {
  String toSlotHHMMSS() {
    return "${twoDigitsFormat.format(hour)}:${twoDigitsFormat.format(minute)}:00";
  }

  String toSlotHHMM() {
    return "${twoDigitsFormat.format(hour)}:${twoDigitsFormat.format(minute)}";
  }
}
