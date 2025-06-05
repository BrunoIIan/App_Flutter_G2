import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/frase_card.dart';
import '../widgets/botao_refresh.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color backgroundColor = Colors.black;

  String frase = 'Clique no botão para ver uma frase.';
  bool carregando = false;

  Future<void> buscarFrase() async {
    setState(() => carregando = true);

    final resposta = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes'),
      headers: {'X-Api-Key': 'ormo4vCwluIB/uYSRkWE4Q==S9tgf6XmgWElE0Vt'},
    );

    if (resposta.statusCode == 200) {
      final dados = json.decode(resposta.body);
      final fraseIngles = dados[0]['quote'];

      setState(() {
        frase = fraseIngles;
        carregando = false;
      });
    } else {
      setState(() {
        frase = "Erro ao buscar frase.";
        carregando = false;
      });
    }
  }

  void escolherCorFundo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Escolha a cor de fundo'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: backgroundColor,
                onColorChanged: (Color cor) {
                  setState(() {
                    backgroundColor = cor;
                  });
                },
                showLabel: false,
              ),
            ),
            actions: [
              TextButton(
                child: Text('Fechar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frase do Dia')),
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              carregando
                  ? CircularProgressIndicator()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FraseCard(texto: frase),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: frase));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Frase copiada!')),
                          );
                        },
                        icon: Icon(Icons.copy),
                        label: Text("Copiar Frase"),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: escolherCorFundo,
                        icon: Icon(Icons.color_lens),
                        label: Text("Cor de Fundo"),
                      ),
                    ],
                  ),
        ),
      ),
      floatingActionButton: BotaoRefresh(onPressed: buscarFrase),
    );
  }
}
