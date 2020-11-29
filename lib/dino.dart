import 'dart:ui' as ui;
import 'dart:ui';
import 'package:dino/sprite/cloud.dart';
import 'package:dino/sprite/horizon.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';

class MyGame extends BaseGame with HasTapableComponents{
  GameBg gameBg;
  Horizon horizon;
  Cloud cloud;

  MyGame(ui.Image spriteImage) {
    gameBg = GameBg(Color.fromRGBO(245, 243, 245, 1));
    horizon = Horizon(spriteImage);
    cloud = Cloud(spriteImage);
    this..add(gameBg)..add(horizon)..add(cloud);
  }

  @override
  void update(double t) {
    horizon.update(t);
    cloud.update(t);
  }
}

class GameBg extends Component with Resizable {
  Color bgColor;

  GameBg([this.bgColor = Colors.white]);

  @override
  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint bgPaint = Paint();
    bgPaint.color = bgColor;
    canvas.drawRect(bgRect, bgPaint);
  }

  @override
  void update(double t) {}
}