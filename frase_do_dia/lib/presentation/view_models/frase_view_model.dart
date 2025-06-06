import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import '../../domain/entities/frase.dart';
import '../../domain/use_cases/obter_frase_do_dia.dart';

class FraseViewModel extends ChangeNotifier {
  final ObterFraseDoDia obterFraseDoDia;

  Frase? _fraseOriginal;
  String _fraseTraduzida = '';
  bool _carregando = false;
  Color _corFundo = Colors.white;
  List<String> _historico = [];

  Frase? get fraseOriginal => _fraseOriginal;
  String get fraseTraduzida => _fraseTraduzida;
  bool get carregando => _carregando;
  Color get corFundo => _corFundo;
  List<String> get historico => _historico;

  FraseViewModel(this.obterFraseDoDia) {
    _carregarCorSalva();
    carregarHistorico();
  }

  Future<void> carregarFrase() async {
    _carregando = true;
    notifyListeners();

    try {
      final frase = await obterFraseDoDia();
      _fraseOriginal = frase;

      final traduzida = await traduzirTexto(frase.texto);
      _fraseTraduzida = traduzida;
    } catch (_) {
      _fraseOriginal = Frase(texto: 'Erro ao obter a frase.');
      _fraseTraduzida = '';
    }

    _carregando = false;
    notifyListeners();
  }

  Future<String> traduzirTexto(String texto) async {
    final translator = GoogleTranslator();
    final traducao = await translator.translate(texto, from: 'en', to: 'pt');
    return traducao.text;
  }

  Future<void> _salvarCor(Color novaCor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('corFundo', novaCor.value);
    _corFundo = novaCor;
    notifyListeners();
  }

  Future<void> _carregarCorSalva() async {
    final prefs = await SharedPreferences.getInstance();
    final int? valor = prefs.getInt('corFundo');
    if (valor != null) {
      _corFundo = Color(valor);
      notifyListeners();
    }
  }

  void alternarCorFundo(BuildContext context) {
    Color corSelecionada = _corFundo;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Escolha a cor de fundo'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _corFundo,
            onColorChanged: (Color cor) {
              corSelecionada = cor;
            },
            showLabel: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _salvarCor(corSelecionada);
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> salvarFraseNoHistorico(String frase) async {
    final prefs = await SharedPreferences.getInstance();
    _historico = prefs.getStringList('historico_frases') ?? [];

    if (!_historico.contains(frase)) {
      _historico.add(frase);
      await prefs.setStringList('historico_frases', _historico);
      notifyListeners();
    }
  }

  Future<void> carregarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    _historico = prefs.getStringList('historico_frases') ?? [];
    notifyListeners();
  }
}
