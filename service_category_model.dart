import 'package:flutter/material.dart';

class ServiceCategoryModel {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  ServiceCategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}