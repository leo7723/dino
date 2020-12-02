import 'dart:ui' as ui;
import 'package:dino/config.dart';
import 'package:dino/sprite/cloud.dart';
import 'package:dino/sprite/dino.dart';
import 'package:dino/sprite/horizon.dart';
import 'package:dino/sprite/obstacle.dart';
import 'package:dino/sprite/score.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';


class MyGame extends BaseGame with HasWidgetsOverlay, HasTapableComponents {
  double currentSpeed;
  GameBg gameBg;
  Horizon horizon;
  Cloud cloud;
  Obstacle obstacle;
  Dino dino;
  Score scoreCom;
  ui.Image spriteImage;
  bool isPlay = false;
  int score = 0;
  var initial = false;

  MyGame(this.spriteImage) {
    currentSpeed = GameConfig.minSpeed;
  }

  Widget createButton({@required IconData icon, double right = 0, double
  bottom = 0,
    ValueChanged<bool>
    onHighlightChanged}) {
    return Positioned(
      right: right,
      bottom: bottom,
      child: MaterialButton(
        onHighlightChanged: onHighlightChanged,
        onPressed: () {
          if (size == null) return;
          if (!initial) {
            initial = true;
            dino = Dino(spriteImage, size);
            scoreCom = Score(spriteImage, size);
            horizon = Horizon(spriteImage, size);
            cloud = Cloud(spriteImage, size);
            obstacle = Obstacle(spriteImage, size);
            this..add(horizon)..add(cloud)..add(obstacle)..add(dino)..add(scoreCom);
          }
          if (isPlay == false) {
            isPlay = true;
            currentSpeed = GameConfig.minSpeed;
            score = 0;
            obstacle.clear();
            dino.startPlay();
          }
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: 50,
          height: 50,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(50)),
            //设置四周边框
            border: new Border.all(width: 2, color: Colors.black),
          ),
          child: Icon(icon, color: Colors.black,),
        ),
      ),
    );
  }

  void debugHit(ui.Image img1, ui.Image img2) {

  }

  @override
  void update(double t) async {
    if (size == null) return;
    if (components.isEmpty) {
      gameBg = GameBg();
      this
        ..add(gameBg)
        ..addWidgetOverlay('upButton', createButton(
          icon: Icons.arrow_drop_up,
          right: 50,
          bottom: 120,
          onHighlightChanged: (isOn) => dino?.jump(isOn),
        ))..addWidgetOverlay('downButton', createButton(
        icon: Icons.arrow_drop_down,
        right: 50,
        bottom: 50,
        onHighlightChanged: (isOn) => dino?.down(isOn),
      ));
    }

    if (isPlay) {
      horizon.updateWithSpeed(t, currentSpeed);
      obstacle.updateWithSpeed(t, currentSpeed);
      cloud.updateWithSpeed(t, currentSpeed);
      dino.updateWithSpeed(t, currentSpeed);
      score++;
      scoreCom.updateWithScore(score);
      if (currentSpeed <= GameConfig.maxSpeed) {
        currentSpeed += GameConfig.acceleration;
      }
      if (await obstacle.hitTest(dino.actualDino, this.debugHit)) {
        dino.die();
        isPlay = false;
      }
    }
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