import 'package:flutter/material.dart';
import 'package:flutter_ds/screen_partition.dart';
import 'package:flutter_ds/tree.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    nLockedDoors = 0;
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('ca'), // Catalan
      ],
      debugShowCheckedModeBanner: false,
      // removes the debug banner that hides the home button
      title: 'ACS',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      // light or dark
      themeMode: ThemeMode.system,
      // see https://docs.flutter.dev/cookbook/design/themes
      home: const ScreenPartition(id: "building"),
    );
  }
}
