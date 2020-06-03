# neumorph_calculator

A new Flutter package project.

## Getting Started

## Use this `Neumorph` widget to create desired neumorphic container.

```dart
const Neumorph({
    Key key,
    this.height = 200.0,
    this.width = 200.0,
    this.radius = 40.0,
    this.distance = 20.0,
    this.intensity = 1.0,
    this.blur = 40.0,
    this.shape = NeumorphShape.pressed,
    this.lightSource = Alignment.topLeft,
    this.child,
    this.color = Colors.white,
}) : assert(intensity != null ? intensity >= 0.0 && intensity <= 1.0 : true),
super(key: key);
```

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# neumorph_calculator
