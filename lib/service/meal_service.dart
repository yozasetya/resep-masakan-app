import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe/models/meal.dart';

class MealCategory {
  final String name;

  MealCategory({required this.name});

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(name: json['strCategory']);
  }
}

class MealService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<MealCategory>> getMealCategories() async {
    final url = Uri.parse('$baseUrl/categories.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List categories = json.decode(response.body)['categories'];
      return categories
          .map((category) => MealCategory.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/filter.php?c=$category');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List meals = json.decode(response.body)['meals'];
      return meals.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<Meal> getMealDetails(String mealId) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$mealId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'][0]; // Ambil item pertama
      return Meal.fromJson(data); // Konversi data ke model Meal
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/search.php?s=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? []; // Handle null response
      return meals.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }
}
