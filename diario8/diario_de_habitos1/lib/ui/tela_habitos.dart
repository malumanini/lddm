import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diario_de_habitos1/dominio/habitos_store.dart';
import 'package:diario_de_habitos1/dominio/tema_store.dart';
import 'package:diario_de_habitos1/ui/tela_detalhe.dart';
import 'package:diario_de_habitos1/ui/tela_novo_habito.dart';

class TelaHabitos extends StatelessWidget {
  const TelaHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: a tela reconstrói sozinha quando a store chama notifyListeners()
    final habitos = context.watch<HabitosStore>().habitos;
    final escuro = context.watch<TemaStore>().escuro;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diário de Hábitos'),
        actions: [
          // BOTÃO DO TEMA (preferência, guardada em shared_preferences)
          IconButton(
            icon: Icon(escuro ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Alternar tema',
            onPressed: () => context.read<TemaStore>().alternar(),
          ),
        ],
      ),
      body: habitos.isEmpty
          ? const Center(
              child: Text('Nenhum hábito ainda. Toque em + para adicionar.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: habitos.length,
              itemBuilder: (context, i) {
                final h = habitos[i];
                return Card(
                  child: ListTile(
                    leading: Icon(h.icone, size: 32),
                    title: Text(h.nome),
                    subtitle: Text(h.meta),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TelaDetalhe(habito: h)),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo hábito',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TelaNovoHabito()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
