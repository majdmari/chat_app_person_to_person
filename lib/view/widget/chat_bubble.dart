import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String measage;
  final Color color;

  const ChatBubble({super.key, required this.measage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Text(
        measage,
        style: const TextStyle(

          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
