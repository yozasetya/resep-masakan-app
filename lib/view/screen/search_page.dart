import 'package:flutter/material.dart';
import 'package:recipe/models/meal.dart';
import 'package:recipe/service/meal_service.dart';
import 'package:recipe/view/meal_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final MealService _mealService = MealService();
  List<Meal> _searchResults = [];
  bool _isLoading = false;

  void _searchMeals(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final results = await _mealService.searchMeals(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCE6E6), // Background hijau muda
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header Hijau Muda
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFCCE6E6), // Warna hijau muda
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar Bulat
                  Image.asset(
                    'images/logo.png', // Ganti dengan path gambar yang sesuai
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  // Teks Deskripsi
                  const Text(
                    "Cari resep apapun pasti ada disini!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 82, 80, 80),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade600),
                      ),
                      child: TextField(
                        onSubmitted: _searchMeals,
                        decoration: const InputDecoration(
                          hintText: "Search any recipes",
                          prefixIcon: Icon(Icons.search,
                              color: Color.fromARGB(255, 145, 145, 145)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bagian Konten Putih dengan Radius di Atas
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                        ? const Center(
                            child: Text(
                              "No recipes found.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final meal = _searchResults[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MealDetailPage(mealId: meal.id),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.white, // Warna putih pada kartu
                                  elevation: 0, // Menghilangkan bayangan
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      // Menambahkan border
                                      color:
                                          Colors.grey, // Warna border abu-abu
                                      width: 1, // Ketebalan border
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      // Meal Image
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          meal.image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Meal Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              meal.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Category: ${meal.category}",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
