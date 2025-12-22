import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'categorized_recipes_page.dart';
import 'area_recipes_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Future<List<dynamic>> fetchCategories() async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final cats = jsonResponse['categories'] as List<dynamic>?;
      return cats ?? <dynamic>[];
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Explore'),
      // ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? <dynamic>[];
          // filter out unwanted categories
          final filtered = categories.where((c) {
            final name = (c['strCategory'] as String? ?? '').toLowerCase();
            return !(name == 'beef' || name == 'pork' || name == 'lamb' || name == 'goat');
          }).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          // Header: a two-column grid of selected countries (areas)
          final areas = [
            'Indian', 'Italian', 'Mexican', 'French', 'Chinese', 'Japanese', 'Thai', 'Spanish', 'Greek', 'Turkish'
          ];

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length + 2, // +2 for country and category headers
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                // build the countries grid header
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Explore by Country', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 3.6,
                      children: areas.map((area) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AreaRecipesPage(area: area)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(area, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const Icon(Icons.public, size: 18),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }

              if (index == 1) {
                // "Explore by Category" header
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Explore by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                );
              }

              final cat = filtered[index - 2] as Map<String, dynamic>;
              final title = cat['strCategory'] as String? ?? '';
              final thumb = cat['strCategoryThumb'] as String? ?? '';
              final desc = cat['strCategoryDescription'] as String? ?? '';

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategorizedRecipesPage(category: title),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: thumb.isNotEmpty
                              ? Image.network(
                                  thumb,
                                  width: 92,
                                  height: 92,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 92,
                                    height: 92,
                                    color: Theme.of(context).colorScheme.surfaceVariant,
                                    child: const Icon(Icons.broken_image),
                                  ),
                                )
                              : Container(
                                  width: 92,
                                  height: 92,
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(
                                desc,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
