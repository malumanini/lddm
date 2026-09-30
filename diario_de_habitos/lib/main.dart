import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'habitos_store.dart';
import 'tela_novo_habito.dart';
import 'teladetalhe.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => HabitosStore()..carregarIniciais(_habitosIniciais),
    child: const DiarioApp(),
  ),
);

const _habitosIniciais = [
  Habito(
    'Beber água',
    'Meta: 8 copos por dia',
    Icons.local_drink,
    'https://images.pexels.com/photos/12551332/pexels-photo-12551332.jpeg?auto=compress&cs=tinysrgb&w=1200',
  ),
  Habito(
    'Ler',
    'Meta: 20 páginas por dia',
    Icons.menu_book,
    'https://images.pexels.com/photos/336407/pexels-photo-336407.jpeg?auto=compress&cs=tinysrgb&w=1200',
  ),
  Habito(
    'Caminhar',
    'Meta: 30 minutos por dia',
    Icons.directions_walk,
    'https://images.pexels.com/photos/663437/pexels-photo-663437.jpeg?auto=compress&cs=tinysrgb&w=1200',
  ),
  Habito(
    'Dormir cedo',
    'Meta: antes das 23h',
    Icons.bedtime,
    'https://images.pexels.com/photos/3807624/pexels-photo-3807624.jpeg?auto=compress&cs=tinysrgb&w=1200',
  ),
];

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
      useMaterial3: true,
    ),
    home: const TelaHabitos(),
  );
}

class TelaHabitos extends StatelessWidget {
  const TelaHabitos({super.key});

  void _abrirNovoHabito(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaNovoHabito()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitos = context.watch<HabitosStore>().habitos;

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Hábitos')),
      body: habitos.isEmpty
          ? const Center(child: Text('Nenhum hábito ainda'))
          : ListView.builder(
              itemCount: habitos.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(habitos[i].icone),
                title: Text(habitos[i].nome),
                subtitle: Text(habitos[i].meta),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TelaDetalhe(
                      nome: habitos[i].nome,
                      meta: habitos[i].meta,
                      icone: habitos[i].icone,
                      imagemUrl: habitos[i].imagemUrl,
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirNovoHabito(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
