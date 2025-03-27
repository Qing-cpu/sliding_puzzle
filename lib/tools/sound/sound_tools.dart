import 'package:flutter_soloud/flutter_soloud.dart';

const _check = 'assets/sounds/tap/mixkit-modern-click-box-check-1120.wav';

class SoundTools {
  static SoLoud? _soLoud;

  static AudioSource? _source;

  static void init() async {
    _soLoud = SoLoud.instance;
    await _soLoud!.init();

    _source = await _soLoud!.loadAsset(_check);
  }

  static void playCheck() async {
    _soLoud!.play(_source!);
  }
}
