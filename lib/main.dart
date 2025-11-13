import 'package:flutter/material.dart';
import 'package:Kleme/views/pages/login_page.dart';
import 'package:Kleme/data/notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
