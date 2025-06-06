import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/services/api_service.dart';
import 'data/repositories/frase_repository_impl.dart';
import 'domain/use_cases/obter_frase_do_dia.dart';
import 'presentation/view_models/frase_view_model.dart';
import 'presentation/views/frase_view.dart';

void main() {
  runApp(const FraseApp());
}

class FraseApp extends StatelessWidget {
  const FraseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final fraseRepository = FraseRepositoryImpl(apiService);
    final obterFraseDoDia = ObterFraseDoDia(fraseRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FraseViewModel(obterFraseDoDia),
        ),
      ],
      child: MaterialApp(
        title: 'Frase do Dia',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const FraseView(),
      ),
    );
  }
}
