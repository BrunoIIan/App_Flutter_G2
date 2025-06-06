import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_models/frase_view_model.dart';

class FraseView extends StatefulWidget {
  const FraseView({super.key});

  @override
  State<FraseView> createState() => _FraseViewState();
}

class _FraseViewState extends State<FraseView> {
  bool iniciou = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FraseViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: viewModel.corFundo,
          appBar: AppBar(title: const Text('Frase do Dia')),
          body: Center(
            child: iniciou
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: viewModel.carregando
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                viewModel.fraseOriginal?.texto ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                viewModel.fraseTraduzida,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await viewModel.carregarFrase();
                      setState(() {
                        iniciou = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Começar'),
                  ),
          ),
          floatingActionButton: iniciou
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'copiar',
                      tooltip: 'Copiar frase',
                      onPressed: () async {
                        final texto = viewModel.fraseOriginal?.texto;
                        if (texto != null && texto.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: texto));
                          await viewModel.salvarFraseNoHistorico(texto);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Frase copiada!')),
                          );
                        }
                      },
                      child: const Icon(Icons.copy),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: 'cor',
                      tooltip: 'Mudar cor de fundo',
                      onPressed: () => viewModel.alternarCorFundo(context),
                      child: const Icon(Icons.color_lens),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: 'refresh',
                      tooltip: 'Nova frase',
                      onPressed: viewModel.carregarFrase,
                      child: const Icon(Icons.refresh),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: 'historico',
                      tooltip: 'Ver histórico',
                      onPressed: () {
                        viewModel.carregarHistorico();
                        showDialog(
                          context: context,
                          builder: (context) {
                            final frases =
                                viewModel.historico.reversed.toList();
                            return AlertDialog(
                              title: const Text('Histórico de Frases'),
                              content: frases.isEmpty
                                  ? const Text('Nenhuma frase copiada ainda.')
                                  : SizedBox(
                                      height: 200,
                                      width: 300,
                                      child: ListView.builder(
                                        itemCount: frases.length,
                                        itemBuilder: (_, i) => ListTile(
                                          title: Text(frases[i]),
                                        ),
                                      ),
                                    ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text('Fechar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.history),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
