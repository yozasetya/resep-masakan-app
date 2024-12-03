class Meal {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String image;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.image,
    required this.ingredients,
    required this.measures,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // Parsing ingredients dan measures
    List<String> ingredients = [];
    List<String> measures = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'] ?? '',
      instructions: json['strInstructions'] ?? '',
      image: json['strMealThumb'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }
}
