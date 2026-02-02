import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path_provider/path_provider.dart'; // 导入 path_provider
const happyPop = 'assets/sounds/tap/happy-pop2.mp3';
const pop4 = 'assets/sounds/tap/ui-pop-sound-316482.mp3';
const deep = 'assets/sounds/tap/808-deep-kick-87379.mp3';
const n = 'assets/sounds/tap/n.mp3';
const completed = 'assets/sounds/tap/smooth-completed.mp3';
const countdown = 'assets/sounds/music/countdown.mp3';
const success = 'assets/sounds/music/success.mp3';

class SoundTools {
  static Future<SoundHandle>? countPlay;
  static SoLoud? _soLoud;
  static AudioSource? _p2;
  static AudioSource? _p4;
  static AudioSource? _deep;
  static AudioSource? _n;
  static AudioSource? _completed;
  static AudioSource? _countdown;
  static AudioSource? _success;
  static bool _isInit = false;

  static void init() async {
    if (_isInit) {
      return;
    }
    _soLoud = SoLoud.instance;
    // --- 修复 macOS 路径问题的代码开始 ---
    if (!kIsWeb && Platform.isMacOS) {
      try {
        // 1. 获取临时目录 (通常是 .../Library/Caches)
        final tempDir = await getTemporaryDirectory();

        // 2. 构建导致报错的中间目录路径 (使用你的 Bundle ID)
        // 注意：这里的 'com.zhangqing.games.slidingpuzzle' 必须与你 entitlements 或 error log 中的一致
        final fixDir = Directory('${tempDir.path}/com.zhangqing.games.slidingpuzzle');

        // 3. 如果该目录不存在，手动递归创建它
        if (!await fixDir.exists()) {
          await fixDir.create(recursive: true);
          debugPrint('macOS fix: Created missing directory: ${fixDir.path}');
        }
      } catch (e) {
        debugPrint('macOS fix error: $e');
      }
    }
    // --- 修复代码结束 ---
    await _soLoud!.init();
    _isInit = true;
    _p2 = await _soLoud!.loadAsset(happyPop);
    _p4 = await _soLoud!.loadAsset(pop4);
    _countdown = await _soLoud!.loadAsset(countdown);
    _deep = await _soLoud!.loadAsset(deep);
    _n = await _soLoud!.loadAsset(n);
    _completed = await _soLoud!.loadAsset(completed);
    _success = await _soLoud!.loadAsset(success);
  }

  static void playPop2() async {
    init();
    _soLoud!.play(_p2!, volume: 0.3);
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

  static void playCountdown() async {
    init();
    countPlay = _soLoud!.play(_countdown!, volume: 0.5);
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
