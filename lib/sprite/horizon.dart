import 'dart:math';
import 'dart:ui' as ui;

import 'package:dino/config.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';

class Horizon extends PositionComponent
  with HasGameRef, Tapable, ComposedComponent, Resizable {

  final ui.Image spriteImage;

  SpriteComponent lastComponent;

  Horizon(this.spriteImage);

  @override
  void resize(ui.Size size) {
    super.resize(size);
    if(components.isEmpty){
      init();
      return;
    }
  }

  void init(){
    double x = 0;
    int horizonW = (size.width/HorizonConfig.w).ceil() + 1;
    for(int i=0; i<horizonW; i++){
      lastComponent = createComposer(x);
      x += HorizonConfig.w;
      add(lastComponent);
    }
  }

  SpriteComponent createComposer(double x){
    final Sprite sprite = Sprite.fromImage(spriteImage,
      width: HorizonConfig.w,
      height: HorizonConfig.h,
      y: HorizonConfig.y,
      x: HorizonConfig.w * (Random().nextInt(3)) + HorizonConfig.x
    );
    SpriteComponent horizon =  SpriteComponent.fromSprite(HorizonConfig.w, HorizonConfig.h, sprite);
    horizon.y = size.height - HorizonConfig.h;
    horizon.x = x;
    return horizon;
  }

  @override
  void update(double t) {
    double x =  t * 50 * 6.5;
    for(final c in components){
      final component = c as SpriteComponent;
      //释放前面超出屏幕的地图, 再重新添加一个在后面
      if(component.x + HorizonConfig.w < 0){
        components.remove(component);
        SpriteComponent horizon = createComposer(lastComponent.x + HorizonConfig.w);
        add(horizon);
        lastComponent = horizon;
        continue;
      }
      component.x -= x;
    }
  }

}