import 'package:Kleme/data/recipe_model.dart';
import 'package:Kleme/data/user_session.dart';
import 'package:Kleme/views/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<dynamic> allFavorites = [];
  bool isLoading = true;
  final String baseUrl = "http://localhost:8000";

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    final userId = UserSession().userId;
    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(Uri.parse("$baseUrl/favorites/$userId"));
      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> data = jsonDecode(response.body);
          allFavorites = data.map((json) => Recipe.fromJson(json)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  Widget _buildListForCategory(String categoryType) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    final filteredList = allFavorites.where((item) {
      return item.type == categoryType ||
          (categoryType == 'Milk Tea' && item.type.toString().contains('Tea'));
    }).toList();

    if (filteredList.isEmpty) {
      return Center(child: Text("No $categoryType favorites yet"));
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return ListTile(
          leading: Image.network(
            item.image ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(item.title),
          subtitle: Text(item.type),
          trailing: const Icon(Icons.favorite, color: Colors.red),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(data: item),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favourites',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color.fromARGB(255, 51, 113, 78),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromARGB(255, 51, 113, 78),
            tabs: [
              Tab(text: 'Cocktail'),
              Tab(text: 'Milk Tea'),
              Tab(text: 'Coffee'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListForCategory('cocktail'),
            _buildListForCategory('milk tea'),
            _buildListForCategory('coffee'),
          ],
        ),
      ),
    );
  }
}
