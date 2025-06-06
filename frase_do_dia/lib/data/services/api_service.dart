import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> fetchFraseDoDia() async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/quotes');

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Api-Key': 'ormo4vCwluIB/uYSRkWE4Q==S9tgf6XmgWElE0Vt',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // A API Ninja retorna uma lista com uma frase
        if (data is List && data.isNotEmpty) {
          return data[0]['quote'];
        } else {
          throw Exception('Resposta da API inesperada.');
        }
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar a frase: $e');
    }
  }
}