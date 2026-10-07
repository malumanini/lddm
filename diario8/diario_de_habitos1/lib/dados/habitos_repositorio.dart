import 'package:flutter/material.dart';
import 'package:diario_de_habitos1/dominio/habito.dart';

class HabitosRepositorio {
  final List<Habito> _memoria = [
    const Habito(
      'Beber água',
      'Meta: 8 copos por dia',
      Icons.local_drink,
      'https://images.pexels.com/photos/12551332/pexels-photo-12551332.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
    const Habito(
      'Ler',
      'Meta: 20 páginas por dia',
      Icons.menu_book,
      'https://images.pexels.com/photos/336407/pexels-photo-336407.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
    const Habito(
      'Caminhar',
      'Meta: 30 minutos por dia',
      Icons.directions_walk,
      'https://images.pexels.com/photos/663437/pexels-photo-663437.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
    const Habito(
      'Dormir cedo',
      'Meta: antes das 23h',
      Icons.bedtime,
      'https://images.pexels.com/photos/3807624/pexels-photo-3807624.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
  ];

  Future<List<Habito>> carregar() async => List.of(_memoria);

  Future<void> salvar(Habito h) async {
    _memoria.add(h);
  }

  Future<void> remover(Habito h) async {
    _memoria.remove(h);
  }

  Future<void> priorizar(Habito h) async {
    _memoria.remove(h);
    _memoria.insert(0, h);
  }
}
