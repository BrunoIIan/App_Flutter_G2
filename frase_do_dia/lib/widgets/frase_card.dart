import 'package:flutter/material.dart';

class FraseCard extends StatelessWidget {
  final String texto;

  const FraseCard({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
