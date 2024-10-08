import 'package:flutter/material.dart';
import 'dart:math';  // Import dart:math for sqrt function
import 'ball.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouncing Ball Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BallSimulationScreen(),
    );
  }
}

class BallSimulationScreen extends StatefulWidget {
  @override
  _BallSimulationScreenState createState() => _BallSimulationScreenState();
}

class _BallSimulationScreenState extends State<BallSimulationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Ball _ball;
  late List<Explosion> _explosions;

  @override
  void initState() {
    super.initState();
    _ball = Ball(x: 150, y: 150, vx: 2, vy: 0, radius: 20);
    _explosions = [];
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(_update);
    _controller.repeat();
  }

  void _update() {
    setState(() {
      _ball.update(300);  // Update with container height
      _explosions.forEach((explosion) => explosion.update());
      _explosions.removeWhere((explosion) => explosion.isFinished);
    });
  }

  void _applyExplosion(double ex, double ey) {
    final dx = _ball.x - ex;
    final dy = _ball.y - ey;
    final distance = sqrt(dx * dx + dy * dy);

    // Simple explosion effect: Inverse distance squared
    final force = 1000 / (distance * distance + 1);  // Add 1 to avoid division by zero
    final fx = force * dx / distance;
    final fy = force * dy / distance;

    _ball.vx += fx;
    _ball.vy += fy;

    // Add explosion to the list
    _explosions.add(Explosion(ex, ey));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bouncing Ball Simulation with Explosions'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: GestureDetector(
            onTapDown: (details) {
              _applyExplosion(details.localPosition.dx, details.localPosition.dy);
            },
            child: CustomPaint(
              painter: BallPainter(_ball, _explosions),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class Explosion {
  final double x, y;
  double radius;
  bool isFinished;

  Explosion(this.x, this.y)
      : radius = 10,
        isFinished = false;

  void update() {
    radius += 2;
    if (radius > 50) {
      isFinished = true;
    }
  }
}

class BallPainter extends CustomPainter {
  final Ball ball;
  final List<Explosion> explosions;

  BallPainter(this.ball, this.explosions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, paint);

    // Draw explosions
    for (var explosion in explosions) {
      paint.color = Colors.red.withOpacity(1 - explosion.radius / 50);
      canvas.drawCircle(Offset(explosion.x, explosion.y), explosion.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}