import 'package:Kleme/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:Kleme/views/pages/login_page.dart';
import 'package:Kleme/data/notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool theme = prefs.getBool(KConstants.themeNotifierKey) ?? false;
    themeNotifier.value = theme;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: value ? Brightness.dark : Brightness.light,
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            bodyMedium: TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
