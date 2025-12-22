import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../../widgets/recipe_widget.dart';
import 'recipe_page.dart';

class AreaRecipesPage extends StatefulWidget {
  final String area;
  const AreaRecipesPage({super.key, required this.area});

  @override
  State<AreaRecipesPage> createState() => _AreaRecipesPageState();
}

class _AreaRecipesPageState extends State<AreaRecipesPage> {
  Future<List<dynamic>> fetchByArea(String area) async {
    final encoded = Uri.encodeComponent(area);
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?a=$encoded');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final meals = jsonResponse['meals'] as List<dynamic>?;
      return meals ?? <dynamic>[];
    } else {
      throw Exception('Failed to load area recipes: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchMealDetails(String id) async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final meals = jsonResponse['meals'] as List<dynamic>?;
      if (meals != null && meals.isNotEmpty) {
        return meals[0] as Map<String, dynamic>;
      }
      throw Exception('No meal details');
    } else {
      throw Exception('Failed to load meal details: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.area)),
      body: FutureBuilder<List<dynamic>>(
        future: fetchByArea(widget.area),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final meals = snapshot.data ?? <dynamic>[];
          if (meals.isEmpty) return const Center(child: Text('No recipes found'));

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index] as Map<String, dynamic>;
              return RecipeWidget(
                meal: meal,
                onTap: () async {
                  final id = meal['idMeal'] as String? ?? '';
                  if (id.isEmpty) return;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );
                  try {
                    final full = await fetchMealDetails(id);
                    Navigator.pop(context); // remove loading
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RecipePage(meal: full)),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load details: $e')));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
