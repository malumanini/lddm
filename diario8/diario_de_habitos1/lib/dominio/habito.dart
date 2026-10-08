import 'package:flutter/material.dart';

class Habito {
  const Habito({
    this.id, // nulo enquanto o hábito não foi gravado no banco
    required this.nome,
    required this.meta,
    required this.icone,
    required this.imagemUrl,
  });

  final int? id;
  final String nome;
  final String meta;
  final IconData icone;
  final String imagemUrl;

  // Objeto -> linha do banco
  Map<String, Object?> toMap() => {
    'id': id,
    'nome': nome,
    'meta': meta,
    'icone': icone.codePoint,
    'imagem_url': imagemUrl,
  };

  // Linha do banco -> objeto
  factory Habito.fromMap(Map<String, Object?> m) => Habito(
    id: m['id'] as int?,
    nome: m['nome'] as String,
    meta: m['meta'] as String,
    icone: IconData(m['icone'] as int, fontFamily: 'MaterialIcons'),
    imagemUrl: m['imagem_url'] as String,
  );
}
