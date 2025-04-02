import 'package:flutter_soloud/flutter_soloud.dart';

const _check = 'assets/sounds/tap/mixkit-modern-click-box-check-1120.wav';
const happy_pop_2 = 'assets/sounds/tap/happy-pop2.mp3';
const happy_pop_3 = 'assets/sounds/tap/happy-pop-3-185288.mp3';
const pop_sound = 'assets/sounds/tap/ui-pop-sound-316482.mp3';
const deep = 'assets/sounds/tap/808-deep-kick-87379.mp3';
const n = 'assets/sounds/tap/n.mp3';
const completed = 'assets/sounds/tap/smooth-completed.mp3';

class SoundTools {
  static SoLoud? _soLoud;

  // static AudioSource? _source;
  static AudioSource? _p2;
  static AudioSource? _p3;
  static AudioSource? _p4;
  static AudioSource? _deep;
  static AudioSource? _n;
  static AudioSource? _completed;

  static void init() async {
    _soLoud = SoLoud.instance;
    await _soLoud!.init();

    _p2 = await _soLoud!.loadAsset(happy_pop_2);
    _p3 = await _soLoud!.loadAsset(happy_pop_3);
    _p4 = await _soLoud!.loadAsset(pop_sound);
    _deep = await _soLoud!.loadAsset(deep);
    _n = await _soLoud!.loadAsset(n);
    _completed = await _soLoud!.loadAsset(completed);
  }

  static void playPop2() async {
    _soLoud!.play(_p2!);
  }

  static void playPop3() async {
    _soLoud!.play(_p3!);
  }

  static void playButtonTap() async {
    _soLoud!.play(_p4!);
  }

  static void playDeep() async {
    _soLoud!.play(_deep!);
  }

  static void playN() async {
    _soLoud!.play(_n!);
  }

  static void playCompleted() async {
    _soLoud!.play(_completed!);
  }
}
