import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Favourites'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Milk Tea'),
              Tab(text: 'Cocktail'),
              Tab(text: 'Coffee'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Milk Tea')),
            Center(child: Text('Cocktail')),
            Center(child: Text('Coffee')),
          ],
        ),
      ),
    );
  }
}
