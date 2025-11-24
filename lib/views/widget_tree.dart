import 'package:flutter/material.dart';
import 'package:Kleme/data/notifier.dart';
import 'package:Kleme/views/widgets/navbar_widget.dart';
import 'package:Kleme/views/pages/home_page.dart';
import 'package:Kleme/views/pages/profile_page.dart';
import 'package:Kleme/views/pages/recipe_page.dart';
import 'package:Kleme/views/pages/chat_page.dart';

List<Widget> pages = [MainHomePage(), RecipePage(), ChatPage(), ProfilePage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (context, value, child) => pages.elementAt(value),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
