import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../widgets/frase_card.dart';
import '../widgets/botao_refresh.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String frase = 'Clique no botão para ver uma frase.';
  String? ultimaBusca;
  bool carregando = false;
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    carregarPreferencias();
  }

  Future<void> buscarFrase() async {
    setState(() => carregando = true);

    final resposta = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes'),
      headers: {'X-Api-Key': 'ormo4vCwluIB/uYSRkWE4Q==S9tgf6XmgWElE0Vt'},
    );

    final agora = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimaBusca', agora);

    if (resposta.statusCode == 200) {
      final dados = json.decode(resposta.body);
      final fraseIngles = dados[0]['quote'];

      setState(() {
        frase = fraseIngles;
        ultimaBusca = agora;
        carregando = false;
      });
    } else {
      setState(() {
        frase = "Erro ao buscar frase.";
        carregando = false;
      });
    }
  }

  Future<void> carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final salva = prefs.getString('ultimaBusca');
    final corSalva = prefs.getInt('corFundo');

    if (salva != null) {
      setState(() {
        ultimaBusca = salva;
      });
    }

    if (corSalva != null) {
      setState(() {
        backgroundColor = Color(corSalva);
      });
    }
  }

  void escolherCorFundo() async {
    Color corSelecionada = backgroundColor;

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Escolha a cor de fundo'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: backgroundColor,
                onColorChanged: (Color cor) {
                  corSelecionada = cor;
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('corFundo', corSelecionada.value);

    setState(() {
      backgroundColor = corSelecionada;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frase do Dia')),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
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
          if (ultimaBusca != null)
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                'Última busca:\n$ultimaBusca',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
        ],
      ),
      floatingActionButton: BotaoRefresh(onPressed: buscarFrase),
    );
  }
}
