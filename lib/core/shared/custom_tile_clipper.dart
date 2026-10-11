import 'package:flutter/material.dart';

class CustomTileClipper extends CustomClipper<Path> {
  const new({this.radius = 32});

  final double radius;

  @override
  Path getClip(Size size) {
    final gapSize = size * .35;

    final path = Path()
      ..moveTo(gapSize.width + radius, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      )
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - radius)
      ..lineTo(0, gapSize.height + radius)
      ..quadraticBezierTo(0, gapSize.height, radius, gapSize.height)
      ..lineTo(gapSize.width - radius, gapSize.height)
      ..quadraticBezierTo(
        gapSize.width,
        gapSize.height,
        gapSize.width,
        gapSize.height - radius,
      )
      ..lineTo(gapSize.width, radius)
      ..quadraticBezierTo(gapSize.width, 0, gapSize.width + radius, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) => true;
}

class PathShadowPainter extends CustomPainter {
  const new(this.clipper);
  final CustomClipper<Path> clipper;

  @override
  void paint(Canvas canvas, Size size) {
    final path = clipper.getClip(size);

    final shadowPath = path.shift(const Offset(6, 6));

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant PathShadowPainter oldDelegate) {
    return oldDelegate.clipper != clipper;
  }
}
