import 'package:Kleme/views/pages/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:Kleme/data/notifier.dart';
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
      'title': 'Cocktails',
      'image':
          'https://th.bing.com/th/id/OIP.-eq4T8xMDRZwhDQFRMm_sAHaHa?w=183&h=183&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'views': '600 views',
      'time': '3 min',
    },
    {
      'title': 'Milk Tea',
      'image':
          'https://th.bing.com/th/id/OIP.OO2s5d4RhTmQrcPoElNVcwHaLH?w=115&h=180&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'views': '100 views',
      'time': '3 min',
    },

    {
      'title': 'Coffee',
      'image':
          'https://th.bing.com/th/id/OIP.GyL5Y1dFW96CGltb8UjDkgHaJN?w=128&h=180&c=7&r=0&o=7&dpr=2.2&pid=1.7&rm=3',
      'views': '100 views',
      'time': '3 min',
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
      'title': 'Piper Plane',
      'image':
          'https://cdn.diffordsguide.com/cocktail/Ov2jPO/default/0/512x.webp',
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
                return [];
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
              height: 320,
              child: CarouselView.weighted(
                flexWeights: const [4, 1],
                consumeMaxWeight: true,
                shrinkExtent: MediaQuery.of(context).size.width * 0.85,
                enableSplash: false,
                onTap: (index) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipePage(initialIndex: index),
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
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => RecipeDetailPage(data: recommendation),
                  //   ),
                  // ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        image: NetworkImage(recommendation['image']!, scale: 2),
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
    child: Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(recipe['image']),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      recipe['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    '${recipe['time']} • ${recipe['views']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
