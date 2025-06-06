import 'package:frase_do_dia/data/repositories/frase_repository.dart';
import 'package:frase_do_dia/data/services/api_service.dart';
import 'package:frase_do_dia/domain/entities/frase.dart';

class FraseRepositoryImpl implements FraseRepository {
  final ApiService apiService;

  FraseRepositoryImpl(this.apiService);

  @override
  Future<Frase> obterFraseDoDia() async {
    final texto = await apiService.fetchFraseDoDia();
    return Frase(texto: texto);
  }
}
