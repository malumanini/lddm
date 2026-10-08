import 'package:flutter/foundation.dart';
import 'package:diario_de_habitos1/dominio/habito.dart';
import 'package:diario_de_habitos1/dados/habitos_repositorio.dart';

class HabitosStore extends ChangeNotifier {
  HabitosStore(this._repo);

  final HabitosRepositorio _repo;
  List<Habito> _habitos = [];

  List<Habito> get habitos => List.unmodifiable(_habitos);

  Future<void> carregar() async {
    _habitos = await _repo.carregar();
    notifyListeners();
  }

  // Recarrega depois de salvar: é o banco que gera o id do hábito novo.
  Future<void> adicionar(Habito h) async {
    await _repo.salvar(h);
    _habitos = await _repo.carregar();
    notifyListeners();
  }

  Future<void> remover(Habito h) async {
    await _repo.remover(h);
    _habitos.remove(h);
    notifyListeners();
  }

  // Mover para o primeiro (só em memória)
  Future<void> priorizar(Habito h) async {
    if (!_habitos.remove(h)) return;
    _habitos.insert(0, h);
    notifyListeners();
  }

  // Mover para o último (só em memória)
  Future<void> despriorizar(Habito h) async {
    if (!_habitos.remove(h)) return;
    _habitos.add(h);
    notifyListeners();
  }
}
