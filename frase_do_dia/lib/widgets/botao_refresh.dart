import 'package:flutter/material.dart';

class BotaoRefresh extends StatelessWidget {
  final VoidCallback onPressed;

  const BotaoRefresh({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.refresh),
      tooltip: 'Nova Frase',
    );
  }
}
