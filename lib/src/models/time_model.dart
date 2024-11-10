import 'package:flutter/material.dart';

@immutable
class TimeModel {
  final int time;
  final Color color;
  final int timeCount;

  const TimeModel({
    required this.time,
    required this.color,
    required this.timeCount,
  });

  String get timeInString => "${time}m";
}

final List<TimeModel> itemList = [
  const TimeModel(
    time: 5,
    color: Color.fromARGB(255, 103, 206, 240),
    timeCount: 1,
  ),
  const TimeModel(
    time: 8,
    color: Color.fromARGB(255, 237, 119, 116),
    timeCount: 2,
  ),
  const TimeModel(
    time: 10,
    color: Color.fromARGB(255, 242, 168, 63),
    timeCount: 3,
  ),
  const TimeModel(
    time: 15,
    color: Color.fromARGB(255, 196, 46, 246),
    timeCount: 4,
  ),
  const TimeModel(
    time: 20,
    color: Color.fromARGB(255, 98, 210, 169),
    timeCount: 5,
  ),
  const TimeModel(
    time: 30,
    color: Color.fromARGB(255, 117, 29, 245),
    timeCount: 6,
  ),
];
