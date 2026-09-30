import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Habito {
  final String nome;
  final String meta;
  final IconData icone;
  final String imagemUrl;

  const Habito(this.nome, this.meta, this.icone, this.imagemUrl);
}

class HabitosStore extends ChangeNotifier {
  final List<Habito> _habitos = [];

  List<Habito> get habitos => List.unmodifiable(_habitos);

  void adicionar(Habito h) {
    _habitos.add(h);
    notifyListeners();
  }

  void carregarIniciais(List<Habito> iniciais) {
    _habitos.addAll(iniciais);
    notifyListeners();
  }

  void remover(int indice) {
    _habitos.removeAt(indice);
    notifyListeners();
  }
}
