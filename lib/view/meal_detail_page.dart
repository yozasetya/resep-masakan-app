import 'package:flutter/material.dart';
import 'package:recipe/service/meal_service.dart';
import '../models/meal.dart';

class MealDetailPage extends StatelessWidget {
  final String mealId;

  const MealDetailPage({required this.mealId, super.key});

  @override
  Widget build(BuildContext context) {
    final MealService mealService = MealService();

    return Scaffold(
      backgroundColor: const Color(0xFFCCE6E6), // Background hijau muda
      appBar: AppBar(
        backgroundColor: const Color(0xFFCCE6E6),
        elevation: 0,
        title: const Text(
          'Meal Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Meal>(
        future: mealService.getMealDetails(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Meal not found.'));
          } else {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Gambar Resep dalam Card
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          meal.image,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Card Detail Resep
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Resep
                            Text(
                              meal.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 8),

                            // Kategori Resep
                            Row(
                              children: [
                                const Icon(Icons.category_outlined,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  meal.category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Label Ingredients
                            const Text(
                              "Ingredients:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Daftar Ingredients
                            ...List.generate(meal.ingredients.length, (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_box_outlined,
                                        color: Colors.teal),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${meal.measures[index]} ${meal.ingredients[index]}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 16),

                            // Label Instructions
                            const Text(
                              "Instructions:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Instruksi
                            Text(
                              meal.instructions,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
