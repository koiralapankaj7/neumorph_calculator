import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CustomisedDecoration extends Decoration {
  final ShapeBorder? shape;
  final double depth;
  final double? blur;
  final List<Color>? colors;
  final double opacity;
  final Alignment lightSource;

  CustomisedDecoration({
    required this.shape,
    required this.depth,
    this.blur,
    this.colors = const [Colors.black87, Colors.white],
    this.opacity = 1.0,
    this.lightSource = Alignment.topLeft,
  })  : assert(shape != null),
        assert(colors == null || colors.length == 2);

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) =>
      _CustomisedDecorationPainter(
          shape, depth, blur, colors, opacity, lightSource);

  @override
  EdgeInsetsGeometry get padding => shape!.dimensions;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is CustomisedDecoration) {
      t = Curves.easeInOut.transform(t);
      return CustomisedDecoration(
        shape: ShapeBorder.lerp(a.shape, shape, t),
        depth: ui.lerpDouble(a.depth, depth, t)!,
        colors: [
          Color.lerp(a.colors![0], colors![0], t)!,
          Color.lerp(a.colors![1], colors![1], t)!,
        ],
        opacity: ui.lerpDouble(a.opacity, opacity, t)!,
      );
    }
    return null;
  }
}

class _CustomisedDecorationPainter extends BoxPainter {
  ShapeBorder? shape;
  double depth;
  double? blur;
  List<Color>? colors;
  double opacity;
  Alignment lightSource;

  _CustomisedDecorationPainter(
    this.shape,
    this.depth,
    this.blur,
    this.colors,
    this.opacity,
    this.lightSource,
  ) {
    if (depth > 0) {
      colors = [
        colors![1],
        colors![0],
      ];
    } else {
      depth = -depth;
    }
    colors = [
      colors![0].withOpacity(opacity),
      colors![1].withOpacity(opacity),
    ];
  }

  @override
  void paint(
      ui.Canvas canvas, ui.Offset offset, ImageConfiguration configuration) {
    final shapePath = shape!.getOuterPath(offset & configuration.size!);
    final rect = shapePath.getBounds();

    final delta = 16 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(depth * 2))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    final paint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth);
    final clipSize = rect.size.aspectRatio > 1
        ? Size(rect.width, rect.height / 2)
        : Size(rect.width / 2, rect.height);
    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final Rect shaderRect =
          alignment.inscribe(Size.square(rect.longestSide), rect);
      paint
        ..shader = ui.Gradient.linear(
          _lightSourceOffset(lightSource, shaderRect),
          _lightSourceOppositeOffset(lightSource, shaderRect),
          colors!,
          stops,
        );
      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    canvas.restore();
  }

  Offset _lightSourceOffset(Alignment lightSource, Rect shaderRect) {
    if (lightSource == Alignment.topLeft) {
      return shaderRect.topLeft;
    }
    if (lightSource == Alignment.topRight) {
      return shaderRect.topRight;
    }
    if (lightSource == Alignment.bottomLeft) {
      return shaderRect.bottomLeft;
    }
    if (lightSource == Alignment.bottomRight) {
      return shaderRect.bottomRight;
    }
    return shaderRect.topLeft;
  }

  Offset _lightSourceOppositeOffset(Alignment lightSource, Rect shaderRect) {
    if (lightSource == Alignment.topLeft) {
      return shaderRect.bottomRight;
    }
    if (lightSource == Alignment.topRight) {
      return shaderRect.bottomLeft;
    }
    if (lightSource == Alignment.bottomLeft) {
      return shaderRect.topRight;
    }
    if (lightSource == Alignment.bottomRight) {
      return shaderRect.topLeft;
    }
    return shaderRect.bottomRight;
  }
}
