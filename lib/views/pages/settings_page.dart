import 'package:flutter/material.dart';
import 'package:Kleme/data/notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.change_circle_outlined),
              title: const Text('Theme'),
              trailing: ValueListenableBuilder(
                valueListenable: themeNotifier,
                builder: (context, value, child) {
                  return Switch.adaptive(
                    thumbIcon: value
                        ? const WidgetStatePropertyAll(Icon(Icons.dark_mode))
                        : const WidgetStatePropertyAll(Icon(Icons.light_mode)),
                    value: value,
                    onChanged: (value) {
                      themeNotifier.value = value;
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              trailing: ValueListenableBuilder(
                valueListenable: languageNotifier,
                builder: (context, value, child) {
                  return DropdownButton(
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'zh', child: Text('中文')),
                    ],
                    value: value,
                    onChanged: (value) {
                      languageNotifier.value = value!;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
