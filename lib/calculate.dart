import 'package:flutter/material.dart';

TimeOfDay addTime(TimeOfDay time, Duration duration) {
  int newMinute = time.minute + duration.inMinutes - (duration.inHours * 60);
  int newHour = time.hour + duration.inHours;
  while (newMinute >= 60) {
    newMinute -= 60;
    newHour++;
  }
  while (newHour >= 24) {
    newHour -= 24;
  }
  return TimeOfDay(hour: newHour, minute: newMinute);
}

TimeOfDay subTime(TimeOfDay time, Duration duration) {
  int newMinute = time.minute - duration.inMinutes + (duration.inHours * 60);
  int newHour = time.hour - duration.inHours;
  while (newMinute < 0) {
    newMinute += 60;
    newHour--;
  }
  while (newHour < 0) {
    newHour += 24;
  }
  return TimeOfDay(hour: newHour, minute: newMinute);
}

double durationToHours(Duration duration) {
  double hours = duration.inHours.toDouble();
  double minutes = duration.inMinutes.toDouble() - (hours * 60);
  return hours + minutes / 60;
}
