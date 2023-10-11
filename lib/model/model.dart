import 'package:flutter/material.dart';

class Target {
  final List<Destination> destinations;

  Target({
    required this.destinations,
  });
}

class Destination {
  final int destinationId;
  final String name;
  final String contactNumber;
  final String location;
  final String scheduledTime;
  final int status;
  final dynamic visitedDate;

  Destination({
    required this.destinationId,
    required this.name,
    required this.contactNumber,
    required this.location,
    required this.scheduledTime,
    required this.status,
    required this.visitedDate,
  });
}

class Pending {
    final int destinationId;
    final String name;
    final String contactNumber;
    final String location;
    final dynamic scheduledDate;
    final String scheduledTime;

    Pending({
        required this.destinationId,
        required this.name,
        required this.contactNumber,
        required this.location,
        required this.scheduledDate,
        required this.scheduledTime,
    });

}

