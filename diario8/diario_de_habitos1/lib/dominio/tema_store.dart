import 'package:flutter/foundation.dart';
import 'package:diario_de_habitos1/dados/preferencias_repositorio.dart';

// Guarda a preferência de tema em memória e persiste via shared_preferences.
class TemaStore extends ChangeNotifier {
  TemaStore(this._repo);

  final PreferenciasRepositorio _repo;
  bool _escuro = false;

  bool get escuro => _escuro;

  Future<void> carregar() async {
    _escuro = await _repo.lerTemaEscuro();
    notifyListeners();
  }

  Future<void> alternar() async {
    _escuro = !_escuro;
    await _repo.salvarTemaEscuro(_escuro);
    notifyListeners();
  }
}
