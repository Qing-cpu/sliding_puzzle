import 'package:flutter_soloud/flutter_soloud.dart';

// const _check = 'assets/sounds/tap/mixkit-modern-click-box-check-1120.wav';
const happy_pop_2 = 'assets/sounds/tap/happy-pop2.mp3';
const happy_pop_3 = 'assets/sounds/tap/happy-pop-3-185288.mp3';
const pop_sound = 'assets/sounds/tap/ui-pop-sound-316482.mp3';
const deep = 'assets/sounds/tap/808-deep-kick-87379.mp3';
const n = 'assets/sounds/tap/n.mp3';
const completed = 'assets/sounds/tap/smooth-completed.mp3';
const countd = 'assets/sounds/music/countd.mp3';
const success = 'assets/sounds/music/success.mp3';

class SoundTools {
  static Future<SoundHandle>? countPlay;
  static SoLoud? _soLoud;
  static AudioSource? _p2;
  static AudioSource? _p3;
  static AudioSource? _p4;
  static AudioSource? _deep;
  static AudioSource? _n;
  static AudioSource? _completed;
  static AudioSource? _countd;
  static AudioSource? _success;
  static bool _isInit = false;

  static void init() async {
    if (_isInit) {
      return;
    }
    _soLoud = SoLoud.instance;
    await _soLoud!.init();
    _isInit = true;
    _p2 = await _soLoud!.loadAsset(happy_pop_2);
    _p3 = await _soLoud!.loadAsset(happy_pop_3);
    _p4 = await _soLoud!.loadAsset(pop_sound);
    _countd = await _soLoud!.loadAsset(countd);
    _deep = await _soLoud!.loadAsset(deep);
    _n = await _soLoud!.loadAsset(n);
    _completed = await _soLoud!.loadAsset(completed);
    _success = await _soLoud!.loadAsset(success);
  }

  static void playPop2() async {
    init();
    _soLoud!.play(_p2!, volume: 0.3);
  }

  static void playPop3() async {
    init();

    _soLoud!.play(_p3!, volume: 0.3);
  }

  static void playButtonTap(double? v) async {
    init();

    _soLoud!.play(_p4!, volume: v ?? 1.0);
  }

  static void playDeep() async {
    init();
    _soLoud!.play(_deep!, volume: 1.0);
  }

  // 到达正确位置是触发
  static void playN() async {
    init();
    _soLoud!.play(_n!, volume: 0.5);
  }

  static void playCompleted() async {
    init();
    _soLoud!.play(_completed!, volume: 1.0);
  }

  static void playSuccess() async {
    init();
    _soLoud!.play(_success!, volume: 1.0);
  }

  static void playCountd() async {
    init();
    countPlay = _soLoud!.play(_countd!, volume: 0.5);
  }

  static void stop() async {
    init();
    if (countPlay != null) {
      final SoundHandle handle = await countPlay!;
      _soLoud!.stop(handle);
      countPlay = null;
    }
  }
}
