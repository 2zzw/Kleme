import 'package:flutter/material.dart';
import 'package:Kleme/data/notifier.dart';
import 'package:Kleme/views/pages/detail_page.dart';
import 'package:Kleme/views/pages/favourite_page.dart';

// Home Search
class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() {
    return _MainHomePageState();
  }
}

class _MainHomePageState extends State<MainHomePage> {
  List<String> categories = ['All', 'Milk Tea', 'Cocktail', 'Coffee'];
  List<Map<String, dynamic>> recipes = [
    {
      'title': 'Milk Tea',
      'image':
          'https://th.bing.com/th/id/OIP.OO2s5d4RhTmQrcPoElNVcwHaLH?w=115&h=180&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'time': '10 min',
      'views': '100 views',
    },
    {
      'title': 'Cocktail',
      'image':
          'https://th.bing.com/th/id/OIP.-eq4T8xMDRZwhDQFRMm_sAHaHa?w=183&h=183&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'time': '10 min',
      'views': '100 views',
    },
    {
      'title': 'Coffee',
      'image':
          'https://th.bing.com/th/id/OIP.GyL5Y1dFW96CGltb8UjDkgHaJN?w=128&h=180&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'time': '10 min',
      'views': '100 views',
    },
  ];
  List<Map<String, dynamic>> recommendations = [
    {
      'title': 'Bubble Tea',
      'image':
          'https://th.bing.com/th/id/OIP.OO2s5d4RhTmQrcPoElNVcwHaLH?w=115&h=180&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'time': '3 min',
      'star': '3.5',
    },
    {
      'title': 'Prickly Pink Margarita',
      'image':
          'https://www.thecocktailproject.com/sites/default/files/styles/recipe_main_img/public/Untitled-1.jpg.webp?itok=1tK4jF-X',
      'time': '10 min',
      'star': '4',
    },
    {
      'title': 'Cappuccino',
      'image':
          'https://th.bing.com/th/id/OIP._IZEtOgoJVsRrx0h6NqiJwHaE7?w=250&h=180&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'time': '5 min',
      'star': '4.5',
    },
  ];
  final SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchAnchor.bar(
          searchController: searchController,
          barElevation: WidgetStateProperty.all(0),
          barBackgroundColor: WidgetStateProperty.all(Colors.transparent),
          barOverlayColor: WidgetStateProperty.all(Colors.transparent),
          barSide: WidgetStateProperty.all(const BorderSide(width: 0)),
          constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavouritePage()),
              );
            },
            // icon: ValueListenableBuilder(
            //   valueListenable: themeNotifier,
            //   builder: (context, value, child) =>
            //       Icon(value ? Icons.dark_mode : Icons.light_mode),
            // ),
            // onPressed: () {
            //   themeNotifier.value = !themeNotifier.value;
            // },
          ),
        ],
      ),
      drawer: const Drawer(),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: ValueListenableBuilder(
              valueListenable: themeNotifier,
              builder: (context, value, child) => Text(
                "Hello, Litchy!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: value ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Container(
            height: 400,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 320, // 控制整体高度
              child: CarouselView.weighted(
                flexWeights: const [4, 1],
                consumeMaxWeight: true,
                shrinkExtent: MediaQuery.of(context).size.width * 0.85,
                enableSplash: false,
                onTap: (index) {
                  final recipe = recipes[index];
                  final tag = 'recipe_${recipe['title']}';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecipeDetailPage(recipe: recipe, tag: tag),
                    ),
                  );
                },
                children: [
                  for (int index = 0; index < recipes.length; index++)
                    _buildHeroCard(context, recipes[index]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ValueListenableBuilder(
              valueListenable: themeNotifier,
              builder: (context, value, child) => Text(
                'Today\'s recommendation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: value ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 400,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.separated(
              itemCount: recommendations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final recommendation = recommendations[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailPage(
                        recipe: recommendation,
                        tag: 'recommendation_${recommendation['title']}',
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        image: NetworkImage(recommendation['image']!, scale: 1),
                      ),
                    ),
                    title: Text(
                      recommendation['title']!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(recommendation['time']!),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Colors.amber),
                        Text(recommendation['star']!),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildHeroCard(BuildContext context, Map<String, dynamic> recipe) {
  final tag = 'recipe_${recipe['title']}';

  return Hero(
    tag: tag,
    transitionOnUserGestures: true,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(recipe['image']!, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${recipe['time']} • ${recipe['views']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
