import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  CategoryChips({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8),
        children: [
          FilterChip(
            label: Text('All'),
            selected: selectedCategory == null,
            onSelected: (_) => onCategorySelected(null),
          ),
          SizedBox(width: 8),
          ...categories.map((category) => Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label:
                      Text(category[0].toUpperCase() + category.substring(1)),
                  selected: category == selectedCategory,
                  onSelected: (_) => onCategorySelected(category),
                ),
              )),
        ],
      ),
    );
  }
}
