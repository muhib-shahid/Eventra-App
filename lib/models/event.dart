import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final String category;
  final String location;
  final String date;
  final String price;
  final String description;
  final String imageUrl;
  final Color accentColor;

  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.date,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.accentColor,
  });
}
