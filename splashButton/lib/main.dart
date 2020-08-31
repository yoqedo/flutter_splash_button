import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SplashButton',
      home: SplashButton(),
    );
  }
}

class SplashButton extends StatefulWidget {
  @override
  _SplashButtonState createState() => _SplashButtonState();
}

class _SplashButtonState extends State<SplashButton> {
  var _width = 150.0;
  var _height = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Splash(
          child: Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500],
                  offset: Offset(5, 5),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-5, -5),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: RadiantGradientMask(
              child: Icon(
                Icons.android,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final GestureTapCallback onTapButton;
  final Tween iconTween;

  Splash({this.child, this.onTap, this.iconTween, this.onTapButton});
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<double> radiusTween;
  Tween<double> borderTween;
  Tween<double> buttonTween;
  Tween<double> iconTween;
  Animation<double> buttonAnimation;
  Animation<double> radiusAnimation;
  Animation<double> borderAnimation;
  Animation<double> iconAnimation;
  AnimationStatus status;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((listener) {
        status = listener;
      });
    radiusTween = Tween<double>(begin: 70, end: 150);
    radiusAnimation = radiusTween
        .animate(CurvedAnimation(curve: Curves.ease, parent: _controller));
    borderTween = Tween<double>(begin: 30, end: 1);
    borderAnimation = borderTween.animate(
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));
    buttonTween = Tween<double>(begin: 150, end: 170);
    buttonAnimation = buttonTween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    iconTween = Tween<double>(begin: 50, end: 60);
    iconAnimation = iconTween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    super.initState();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SplashPaint(
        radius: radiusAnimation.value,
        borderWidth: borderAnimation.value,
        status: status,
      ),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedButton(
          radius: buttonAnimation.value,
          iconSize: iconAnimation.value,
        ),
      ),
    );
  }
}

//Create CustomPainter
class SplashPaint extends CustomPainter {
  final double radius;
  final double borderWidth;
  final AnimationStatus status;
  final Gradient gradient;

  SplashPaint({this.radius, this.borderWidth, this.status, this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey[300]
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = LinearGradient(
        colors: [
          Color.fromRGBO(131, 58, 180, 1).withOpacity(0.8),
          Color.fromRGBO(253, 29, 29, 1),
          Color.fromRGBO(252, 176, 69, 1).withOpacity(0.8),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ));

    if (status == AnimationStatus.forward) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//Return Function for Gradient Icon
class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        colors: [
          Color.fromRGBO(131, 58, 180, 1),
          Color.fromRGBO(253, 29, 29, 1),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final double radius;
  final double iconSize;

  const AnimatedButton({Key key, this.radius, this.iconSize}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.radius,
      width: widget.radius,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(5, 5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: RadiantGradientMask(
        child: Icon(
          Icons.android,
          size: widget.iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
