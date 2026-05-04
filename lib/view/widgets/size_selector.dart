import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({super.key});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  int selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    final sizes = ['S', 'M', 'L', 'XL'];
    return Row(
      children: List.generate(sizes.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(sizes[index]),
            selected: selectedSize == index,
            onSelected: (bool selected) {
              setState(() {
                selectedSize = selected ? index : selectedSize;
              });
            },
            selectedColor: Colors.blue,
            backgroundColor: Colors.grey,
            labelStyle: TextStyle(
              color: selectedSize == index ? Colors.white : Colors.black,
            ),
          ),
        );
      }),
    );
  }
}
