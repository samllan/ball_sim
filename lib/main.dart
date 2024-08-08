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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bouncing Ball Simulation'),
      ),
      body: CustomPaint(
        painter: BallPainter(_ball),
        child: Container(),
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