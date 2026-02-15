import 'package:flutter/material.dart';
import 'sfx_manager.dart';

/// A NavigatorObserver that plays a 'back' sound whenever a route is popped.
class SfxNavigatorObserver extends NavigatorObserver {
  final SfxManager sfx;

  SfxNavigatorObserver(this.sfx);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != 'mute_back_sound') {
      sfx.playBack();
    }
  }
}
