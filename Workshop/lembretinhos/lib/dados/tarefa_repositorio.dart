import 'package:flutter/foundation.dart';

import '../dominio/tarefa.dart';

class TarefaRepositorio extends ValueNotifier<List<Tarefa>> {
  TarefaRepositorio._()
      : super([
          Tarefa(id: 1, emoji: '🌸', titulo: 'Regar as plantinhas'),
          Tarefa(id: 2, emoji: '📚', titulo: 'Estudar para o workshop'),
          Tarefa(id: 3, emoji: '🧋', titulo: 'Tomar um bubble tea', feita: true),
        ]);

  static final instance = TarefaRepositorio._();

  int _proximoId = 4;

  Tarefa? byId(int id) {
    for (final t in value) {
      if (t.id == id) return t;
    }
    return null;
  }

  void add(String emoji, String titulo) {
    value = [...value, Tarefa(id: _proximoId++, emoji: emoji, titulo: titulo)];
  }

  void alternarFeita(int id) {
    final t = byId(id);
    if (t == null) return;
    t.feita = !t.feita;
    notifyListeners();
  }

  void definirLembrete(int id, String? texto) {
    final t = byId(id);
    if (t == null) return;
    t.lembrete = texto;
    notifyListeners();
  }
}
