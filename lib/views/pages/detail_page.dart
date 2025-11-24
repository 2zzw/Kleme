import 'package:Kleme/data/recipe_model.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe data;

  const RecipeDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String title = data.title ?? 'Unknown Recipe';
    final String imageUrl = data.image ?? '';
    final String description = data.description ?? '';
    final List<String> ingredients = List<String>.from(data.ingredients ?? []);
    final List<String> steps = List<String>.from(data.steps ?? []);
    final List<String> alcoholInfo = List<String>.from(
      data.alcoholContent ?? [],
    );
    final String nutrition = data.nutrition ?? '';
    final String strength = data.strength ?? '';
    final String sweetSour = data.sweetSour ?? '';
    final String glass = data.glass ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, title, imageUrl),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(title, strength, sweetSour),
                  const SizedBox(height: 16),
                  _buildInfoChips(nutrition, alcoholInfo, description, glass),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context,
                    "Ingredients",
                    Icons.shopping_basket_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildIngredientsList(ingredients),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    context,
                    "Instructions",
                    Icons.restaurant_menu,
                  ),
                  const SizedBox(height: 12),
                  _buildStepsList(context, steps),
                  const SizedBox(height: 40), // 底部留白
                ],
              ),
            ),
          ),
        ],
      ),
      // 悬浮按钮：收藏
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.favorite_border),
      ),
    );
  }

  // 1. 视差滚动头部
  Widget _buildSliverAppBar(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    return SliverAppBar(
      expandedHeight: 300.0, // 图片展开高度
      pinned: true, // 上滑时是否固定在顶部
      stretch: true, // 允许下拉放大
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            // 添加一个渐变遮罩，保证文字在浅色图片上也清晰可见
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const ContainerWithBackground(icon: Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const ContainerWithBackground(icon: Icons.share),
          onPressed: () {},
        ),
      ],
    );
  }

  // 2. 标题与口味标签
  Widget _buildTitleSection(String title, String strength, String sweetSour) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (strength.isNotEmpty)
              _buildTag(
                Colors.orange.shade100,
                Colors.orange.shade900,
                strength,
              ),
            const SizedBox(width: 8),
            if (sweetSour.isNotEmpty)
              _buildTag(
                Colors.green.shade100,
                Colors.green.shade900,
                sweetSour,
              ),
          ],
        ),
      ],
    );
  }

  // 3. 重构后的详情展示组件
  Widget _buildInfoChips(
    String nutrition,
    List<String> alcoholList, // 注意：这里改为 List<String>
    String description,
    String glass,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. 描述区域 (Description) ---
        // 使用 Quote 风格，增加一点设计感
        Container(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.orange.shade300, width: 4),
            ),
          ),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 15,
              height: 1.6, // 增加行高，提升长文本阅读体验
              color: Colors.grey.shade800,
              fontStyle: FontStyle.italic, // 斜体增加叙事感
            ),
          ),
        ),

        const SizedBox(height: 20),

        // --- 2. 核心参数卡片 (Glass & Nutrition) ---
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // 增加轻微的阴影，制造层级感
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            children: [
              // 第一行：酒杯与热量并排
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧：酒杯信息 (占据 60% 宽度，因为文字较多)
                  Expanded(
                    flex: 3,
                    child: _buildDetailItem(
                      Icons.wine_bar,
                      "Preferred Glass",
                      glass,
                    ),
                  ),
                  // 中间分割线
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  // 右侧：热量信息 (占据 40% 宽度)
                  Expanded(
                    flex: 2,
                    child: _buildDetailItem(
                      Icons.local_fire_department_rounded,
                      "Nutrition",
                      // 正则提取数字: "183 calories" -> "183 kcal"
                      "${nutrition.replaceAll(RegExp(r'[^0-9]'), '')} kcal",
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: Color(0xFFEEEEEE)),
              ),

              // --- 3. 酒精含量列表 (Alcohol List) ---
              // 放在卡片内部下方，或者独立出来。这里放在内部作为 "Technical Specs"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.science_outlined,
                    size: 20,
                    color: Colors.blueGrey.shade400,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alcohol Content",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 使用 Wrap 或 Column 渲染列表
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: alcoholList.map((item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.blueGrey.shade100,
                                ),
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 辅助小组件：用于构建 Glass 和 Nutrition 的单项
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.orange), // 主题色图标
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label, // 标题 (Label)
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value, // 内容 (Value)
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4. 描述文本
  Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
    );
  }

  // 5. 配料列表
  Widget _buildIngredientsList(List<String> ingredients) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true, // 关键：在 ScrollView 中嵌套 ListView
      physics: const NeverScrollableScrollPhysics(), // 禁止自身滚动
      itemCount: ingredients.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredients[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 6. 步骤列表
  Widget _buildStepsList(BuildContext context, List<String> steps) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (index != steps.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.grey.shade200,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    steps[index],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 辅助组件 ---

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTag(Color bg, Color text, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        content,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value.length > 15 ? "${value.substring(0, 12)}..." : value, // 防止溢出
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

// 为了让 AppBar 上的图标在白色和深色背景下都看清，加一个半透明背景
class ContainerWithBackground extends StatelessWidget {
  final IconData icon;
  const ContainerWithBackground({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black26,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
