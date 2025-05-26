import 'package:flutter/material.dart';
import 'package:frase_do_dia/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(FraseApp());
}

bool carregando = false;

class FraseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frase do Dia',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class FraseHomePage extends StatefulWidget {
  @override
  _FraseHomePageState createState() => _FraseHomePageState();
}

class _FraseHomePageState extends State<FraseHomePage> {
  String frase = "Clique no botão para ver uma frase.";
  String autor = "";

  Future<void> buscarFrase() async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/quotes');
    setState(() {
      carregando = true;
    });
    try {
      final resposta = await http.get(
        url,
        headers: {'X-Api-Key': 'ormo4vCwluIB/uYSRkWE4Q==S9tgf6XmgWElE0Vt'},
      );

      if (resposta.statusCode == 200) {
        final dados = json.decode(resposta.body);
        setState(() {
          frase = dados[0]['quote'];
          autor = "- ${dados[0]['author']}";
        });
      } else {
        setState(() {
          frase = "Erro ao carregar frase.";
          autor = "";
        });
      }
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frase do Dia')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child:
              carregando
                  ? CircularProgressIndicator()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        frase,
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: '$frase $autor'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Frase copiada!')),
                          );
                        },
                        icon: Icon(Icons.copy),
                        label: Text("Copiar Frase"),
                      ),
                      SizedBox(height: 20),
                      Text(
                        autor,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: buscarFrase,
        child: Icon(Icons.refresh),
        tooltip: 'Nova Frase',
      ),
    );
  }
}
