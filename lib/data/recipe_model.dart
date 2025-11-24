class Recipe {
  final String id;
  final String title;
  final String image;
  final String type;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String glass;
  final String strength;
  final String sweetSour;
  final List<String> alcoholContent;
  final String nutrition;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    this.type = '',
    this.description = '',
    this.glass = '',
    this.strength = '',
    this.sweetSour = '',
    this.alcoholContent = const [],
    this.ingredients = const [],
    this.steps = const [],
    this.nutrition = '',
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown',
      image: json['image']?.toString() ?? '',
      strength: json['strength']?.toString() ?? '',
      sweetSour: json['sweet_sour']?.toString() ?? '',
      alcoholContent: _safeParseList(json['alcohol_content']),
      ingredients: _safeParseList(json['ingredients']),
      steps: _safeParseList(json['steps']),
      description: json['description']?.toString() ?? '',
      glass: json['glass']?.toString() ?? '',
      nutrition: json['nutrition']?.toString() ?? '',
    );
  }

  static List<String> _safeParseList(dynamic data) {
    if (data == null) {
      return [];
    }
    if (data is List) {
      return data.map((item) => item.toString()).toList();
    }
    if (data is String) {
      if (data.trim().isEmpty) return [];
      return [data];
    }
    return [data.toString()];
  }
}
