import 'dart:convert';
import 'package:Kleme/views/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/recipe_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Recipes",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: "Cocktails"),
            Tab(text: "Coffee"),
            Tab(text: "Milk Tea"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RecipeListContainer(category: 'cocktail'),
          RecipeListContainer(category: 'coffee'),
          RecipeListContainer(category: 'milktea'),
        ],
      ),
    );
  }
}

class RecipeListContainer extends StatefulWidget {
  final String category;
  const RecipeListContainer({super.key, required this.category});

  @override
  State<RecipeListContainer> createState() => _RecipeListContainerState();
}

class _RecipeListContainerState extends State<RecipeListContainer>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Recipe>> _futureRecipes;

  @override
  void initState() {
    super.initState();
    _futureRecipes = fetchRecipes(widget.category);
  }

  @override
  bool get wantKeepAlive => true;

  Future<List<Recipe>> fetchRecipes(String category) async {
    String baseUrl = 'http://127.0.0.1:8000';
    final url = Uri.parse('$baseUrl/recipes/category/$category');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Recipe.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Recipe>>(
      future: _futureRecipes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text("Error: ${snapshot.error}"),
                TextButton(
                  onPressed: () => setState(
                    () => _futureRecipes = fetchRecipes(widget.category),
                  ),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No recipes found."));
        }
        final recipes = snapshot.data!;
        return WaterfallList(items: recipes);
      },
    );
  }
}

class WaterfallList extends StatelessWidget {
  final List<Recipe> items;

  const WaterfallList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    List<Recipe> leftColumn = [];
    List<Recipe> rightColumn = [];

    for (var i = 0; i < items.length; i++) {
      if (i % 2 == 0)
        leftColumn.add(items[i]);
      else
        rightColumn.add(items[i]);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftColumn
                  .map((item) => RecipeCard(data: item))
                  .toList(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: rightColumn
                  .map((item) => RecipeCard(data: item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe data; // 这里类型变成了 Recipe

  const RecipeCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 保持之前的 UI 布局不变，只是取值方式从 map['key'] 变成了 data.property
    return GestureDetector(
      onTap: () {
        // 跳转时可能需要把 Model 转回 Map 或者让详情页也支持 Model
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipeDetailPage(data: data)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Hero(
                tag: data.id, // Hero 动画，连接列表页和详情页
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: data.image, // 你的图片 URL
                    fit: BoxFit.cover,

                    // A. 占位图：当图片正在下载时，显示一个灰色的“骨架屏”动画
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 150, // 设置一个默认高度，防止布局跳动
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),

                    // B. 错误图：如果图片 404 或者断网，显示这个
                    errorWidget: (context, url, error) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey),
                          SizedBox(height: 4),
                          Text(
                            "无法加载",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),

                    // C. 动画效果：加载完成后，图片会淡入，而不是生硬地弹出
                    fadeInDuration: const Duration(milliseconds: 500),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // 标签行
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      // 如果有 strength 数据
                      if (data.strength.isNotEmpty)
                        _buildMiniTag(
                          data.strength.toString().split(' ').last,
                          Colors.orange.shade50,
                          Colors.orange,
                        ),
                      // 稍微展示一点描述
                      if (data.sweetSour.isNotEmpty)
                        _buildMiniTag(
                          data.sweetSour,
                          Colors.green.shade50,
                          Colors.green,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 底部栏：点赞 icon 等
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Read more",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTag(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
