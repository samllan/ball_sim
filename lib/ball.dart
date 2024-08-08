import 'package:flutter/material.dart';

class Ball {
  double x, y;
  double vx, vy;
  final double radius;

  Ball({required this.x, required this.y, required this.vx, required this.vy, required this.radius});

  void update(double screenHeight) {
    // Update position
    x += vx;
    y += vy;

    // Apply gravity
    vy += 0.5;

    // Bounce off the floor and ceiling
    if (y + radius > screenHeight) {
      y = screenHeight - radius;
      vy = -vy * 0.8; // Apply some energy loss
    } else if (y - radius < 0) {
      y = radius;
      vy = -vy * 0.8;
    }

    // Bounce off the walls
    if (x + radius > 300) {
      x = 300 - radius;
      vx = -vx * 0.8;
    } else if (x - radius < 0) {
      x = radius;
      vx = -vx * 0.8;
    }
  }
}