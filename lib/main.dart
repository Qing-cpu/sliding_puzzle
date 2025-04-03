import 'package:flutter/material.dart';
import 'package:sliding_puzzle/pages/init_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_puzzle/tools/tools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBTools.init(null);
  SoundTools.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '拼图滑块',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: const InitPage(),
    );
  }
}
