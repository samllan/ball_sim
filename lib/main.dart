import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _ball = Ball(x: 150, y: 150, vx: 2, vy: 0, radius: 20);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(_update);
    _controller.repeat();
  }

  void _update() {
    setState(() {
      _ball.update(MediaQuery.of(context).size.height);
    });
  }

  void _applyExplosion(double ex, double ey) {
    final dx = _ball.x - ex;
    final dy = _ball.y - ey;
    final distance = (dx * dx + dy * dy).sqrt();

    // Simple explosion effect: Inverse distance squared
    final force = 1000 / (distance * distance + 1);  // Add 1 to avoid division by zero
    final fx = force * dx / distance;
    final fy = force * dy / distance;

    _ball.vx += fx;
    _ball.vy += fy;
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
      body: GestureDetector(
        onTapDown: (details) {
          _applyExplosion(details.localPosition.dx, details.localPosition.dy);
        },
        child: CustomPaint(
          painter: BallPainter(_ball),
          child: Container(),
        ),
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final Ball ball;

  BallPainter(this.ball);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}