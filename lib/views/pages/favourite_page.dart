import 'package:Kleme/data/user_session.dart';
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

  // 拉取当前用户的所有收藏
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
          allFavorites = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  // 辅助函数：根据类型过滤列表
  Widget _buildListForCategory(String categoryType) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    // 过滤数据 (注意：你的数据库里存的是 "Cocktail", "Milk Tea" 还是 "Bubble Tea"?
    // 这里要和数据库字段 type 对应，假设数据库存的是 "Cocktail", "Tea", "Coffee")
    // 这里假设数据库的 type 字段和你的 Tab 文字有对应关系
    final filteredList = allFavorites.where((item) {
      // 这里做一个简单的模糊匹配或精确匹配
      return item['type'] == categoryType ||
          (categoryType == 'Milk Tea' &&
              item['type'].toString().contains('Tea'));
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
            item['image'] ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(item['title']),
          subtitle: Text(item['type']),
          trailing: const Icon(Icons.favorite, color: Colors.red),
          onTap: () {
            // 点击跳转详情页逻辑...
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
            _buildListForCategory('milk tea'), // 确保这个名字能匹配到数据库里的 type
            _buildListForCategory('coffee'),
          ],
        ),
      ),
    );
  }
}
