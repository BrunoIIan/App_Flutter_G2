import 'package:frase_do_dia/data/repositories/frase_repository.dart';
import 'package:frase_do_dia/domain/entities/frase.dart';

class ObterFraseDoDia {
  final FraseRepository repository;

  ObterFraseDoDia(this.repository);

  Future<Frase> call() async {
    return await repository.obterFraseDoDia();
  }
}
