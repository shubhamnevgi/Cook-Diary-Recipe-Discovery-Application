import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatelessWidget {
  final Map<String, dynamic> meal;

  const RecipePage({super.key, required this.meal});

  List<Map<String, String>> _extractIngredients(Map<String, dynamic> meal) {
    final List<Map<String, String>> items = [];
    for (var i = 1; i <= 20; i++) {
      final ing = (meal['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (meal['strMeasure$i'] as String?)?.trim() ?? '';
      if (ing.isNotEmpty) {
        items.add({'ingredient': ing, 'measure': measure});
      }
    }
    return items;
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore failure silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = meal['strMeal'] as String? ?? 'Recipe';
    final thumb = meal['strMealThumb'] as String? ?? '';
    final instructions = meal['strInstructions'] as String? ?? '';
    final category = meal['strCategory'] as String? ?? '';
    final area = meal['strArea'] as String? ?? '';
    final tags = (meal['strTags'] as String?) ?? '';
    final youtube = (meal['strYoutube'] as String?) ?? '';
    final source = (meal['strSource'] as String?) ?? '';

    final ingredients = _extractIngredients(meal);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (thumb.isNotEmpty)
              Image.network(
                thumb,
                fit: BoxFit.cover,
                height: 260,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 260,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (category.isNotEmpty) Chip(label: Text(category)),
                      const SizedBox(width: 8),
                      if (area.isNotEmpty) Chip(label: Text(area)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (tags.isNotEmpty) ...[
                    Text('Tags', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: tags
                          .split(',')
                          .map((t) => Chip(label: Text(t.trim())))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                  ],

                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: ingredients.map((it) {
                          return Row(
                            children: [
                              Expanded(child: Text(it['ingredient'] ?? '')),
                              const SizedBox(width: 8),
                              Text(
                                it['measure'] ?? '',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Text(
                  //   'Instructions',
                  //   style: Theme.of(context).textTheme.titleMedium,
                  // ),
                  const SizedBox(height: 8),
                  _InstructionsView(instructions: instructions),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      if (youtube.isNotEmpty) ...[
                        ElevatedButton.icon(
                          onPressed: () => _openUrl(youtube),
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text('Watch Tutorial'),
                        ),
                        const SizedBox(height: 8),
                      ],

                      if (source.isNotEmpty) ...[
                        TextButton.icon(
                          onPressed: () => _openUrl(source),
                          icon: const Icon(Icons.link),
                          label: const Text('Article Source'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionsView extends StatefulWidget {
  final String instructions;
  const _InstructionsView({Key? key, required this.instructions}) : super(key: key);

  @override
  State<_InstructionsView> createState() => _InstructionsViewState();
}

class _InstructionsViewState extends State<_InstructionsView> {
  bool _collapsed = false;

  List<String> _buildSteps(String text) {
    final lines = text.split(RegExp(r'\r?\n')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.length > 1) return lines;

    // Single paragraph -> split into sentences
    final sentences = text.split(RegExp(r'(?<=[.!?])\s+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (sentences.length > 1) return sentences;

    // Fallback to whole text
    return [text.trim()];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps(widget.instructions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            IconButton(
              tooltip: _collapsed ? 'Expand' : 'Collapse',
              onPressed: () => setState(() => _collapsed = !_collapsed),
              icon: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
            ),
            IconButton(
              tooltip: 'Copy instructions',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.instructions));
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Instructions copied')));
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (!_collapsed)
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: steps.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final step = steps[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(fontSize: 16, height: 1.45),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}

