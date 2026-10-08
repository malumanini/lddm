import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:diario_de_habitos1/dominio/habito.dart';

class HabitosRepositorio {
  // Hábitos que já vêm no app na primeira abertura.
  static const _padrao = <Habito>[
    Habito(
      nome: 'Beber água',
      meta: 'Meta: 8 copos por dia',
      icone: Icons.local_drink,
      imagemUrl: 'https://images.pexels.com/photos/12551332/pexels-photo-12551332.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
    Habito(
      nome: 'Ler',
      meta: 'Meta: 20 páginas por dia',
      icone: Icons.menu_book,
      imagemUrl: 'https://images.pexels.com/photos/336407/pexels-photo-336407.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
    Habito(
      nome: 'Caminhar',
      meta: 'Meta: 30 minutos por dia',
      icone: Icons.directions_walk,
      imagemUrl: 'https://images.pexels.com/photos/663437/pexels-photo-663437.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
    Habito(
      nome: 'Dormir cedo',
      meta: 'Meta: antes das 23h',
      icone: Icons.bedtime,
      imagemUrl: 'https://images.pexels.com/photos/3807624/pexels-photo-3807624.jpeg?auto=compress&cs=tinysrgb&w=1200',
    ),
  ];

  // Abre o banco. O onCreate roda UMA vez, quando o arquivo é criado.
  // Se mudar o CREATE TABLE ou os hábitos padrão, desinstale o app
  // para recriar o arquivo.
  Future<Database> _abrir() async => openDatabase(
    join(await getDatabasesPath(), 'habitos.db'),
    version: 1,
    onCreate: (db, _) async {
      await db.execute(
        'CREATE TABLE habitos('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'nome TEXT NOT NULL, '
        'meta TEXT NOT NULL, '
        'icone INTEGER NOT NULL, '
        'imagem_url TEXT NOT NULL)',
      );
      // Insere os hábitos padrão junto com a criação da tabela.
      for (final h in _padrao) {
        await db.insert('habitos', h.toMap());
      }
    },
  );

  Future<List<Habito>> carregar() async {
    final db = await _abrir();
    final linhas = await db.query('habitos', orderBy: 'id');
    return linhas.map(Habito.fromMap).toList();
  }

  Future<void> salvar(Habito h) async {
    final db = await _abrir();
    await db.insert('habitos', h.toMap());
  }

  Future<void> remover(Habito h) async {
    final db = await _abrir();
    await db.delete('habitos', where: 'id = ?', whereArgs: [h.id]);
  }
}
