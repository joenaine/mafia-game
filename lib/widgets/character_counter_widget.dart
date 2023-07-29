import 'package:flutter/material.dart';

class CharacterCounterWidget extends StatelessWidget {
  const CharacterCounterWidget(
      {Key? key,
      this.count = 0,
      this.character,
      this.decrement,
      this.increment})
      : super(key: key);

  final int? count;
  final String? character;
  final VoidCallback? decrement;
  final VoidCallback? increment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          character ?? '',
          style: const TextStyle(fontSize: 30),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: decrement,
              child: const Icon(
                Icons.remove,
                size: 40,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: increment,
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ],
        )
      ],
    );
  }
}
