import 'package:flutter/material.dart';
// import 'package:flutter_application_1/widgets/hero_widget.dart';
import 'package:flutter_application_1/widgets/recipe_widget.dart';
import 'package:flutter_application_1/views/pages/recipe_page.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
// import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    // do not prefetch here — FutureBuilder will handle fetching
    super.initState();
    _searchController.text = '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchMeals([String query = '']) async {
    final encoded = Uri.encodeComponent(query);
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$encoded',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      final meals = jsonResponse['meals'] as List<dynamic>?;
      return meals ?? <dynamic>[];
    } else {
      throw Exception('Failed to load meals: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child: Column(
          children: [
            // Container(child: const HeroWidget(), color: Colors.red),
            SizedBox(height: 15.0),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'What do you want to cook today?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                          });
                        },
                      ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _query = value.trim();
                });
              },
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchMeals(_query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final meals = snapshot.data ?? <dynamic>[];
                    if (meals.isEmpty) {
                      return const Center(child: Text('No recipes found'));
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipePage(meal: meal),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
