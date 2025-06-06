

import 'package:frase_do_dia/domain/entities/frase.dart';

abstract class FraseRepository {
  Future<Frase> obterFraseDoDia();
}