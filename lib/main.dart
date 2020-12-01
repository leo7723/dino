import 'dart:ui' as ui;

import 'package:dino/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.util
    ..fullScreen()
    ..setLandscape();
  ui.Image image = await Flame.images.load("dino.png");
  runApp(MyGame(image).widget);
}