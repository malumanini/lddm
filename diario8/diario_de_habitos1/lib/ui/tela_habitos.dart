import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diario_de_habitos1/dominio/habitos_store.dart';
import 'tela_novo_habito.dart';
import 'tela_detalhe.dart';

class TelaHabitos extends StatefulWidget {
  const TelaHabitos({super.key});

  @override
  State<TelaHabitos> createState() => _TelaHabitosState();
}

class _TelaHabitosState extends State<TelaHabitos> {
  @override
  void initState() {
    super.initState();
    context.read<HabitosStore>().carregar();
  }

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
                    builder: (_) => TelaDetalhe(habito: habitos[i]),
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