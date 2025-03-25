import 'package:flutter/material.dart';
import 'package:sliding_puzzle/pages/start_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'data/db_tools/db_tools.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DBTools.init(null);
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
