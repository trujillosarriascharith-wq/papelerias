import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 42,
          height: 4.5,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFF0F3),
                child: Icon(Icons.menu_book_rounded, color: Color(0xFFFF8FAB)),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asesor Papeleria Juan Jose',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'En linea - Respuestas al instante',
                    style: TextStyle(color: Color(0xFFFF8FAB), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFFFC2D1)),
      ],
    );
  }
}