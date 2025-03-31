import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'pages/start_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_puzzle/tools/tools.dart';

void main() {
  () async => await GameAuth.signIn();

  WidgetsFlutterBinding.ensureInitialized();
  DBTools.init(null);
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
      home: const StartPage(),
    );
  }
}
