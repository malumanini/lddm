import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diario_de_habitos1/dominio/habito.dart';
import 'package:diario_de_habitos1/dominio/habitos_store.dart';

class TelaDetalhe extends StatelessWidget {
  const TelaDetalhe({super.key, required this.habito});

  final Habito habito;

  // Faz a ação na store e volta para a lista.
  // A lista atualiza sozinha porque a store chama notifyListeners().
  Future<void> _executar(
    BuildContext context,
    Future<void> Function(HabitosStore store) acao,
  ) async {
    await acao(context.read<HabitosStore>());
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habito.nome),
        actions: [
          // BOTÃO EXCLUIR
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir hábito',
            onPressed: () => _executar(context, (s) => s.remover(habito)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Banner(habito: habito),
          const SizedBox(height: 16),
          _CartaoMeta(habito: habito),
          const SizedBox(height: 24),

          // BOTÃO PRIORIZAR (move para o primeiro)
          FilledButton.icon(
            icon: const Icon(Icons.arrow_upward),
            label: const Text('Priorizar'),
            onPressed: () => _executar(context, (s) => s.priorizar(habito)),
          ),
          const SizedBox(height: 12),

          // BOTÃO DESPRIORIZAR (move para o último)
          OutlinedButton.icon(
            icon: const Icon(Icons.arrow_downward),
            label: const Text('Despriorizar'),
            onPressed: () => _executar(context, (s) => s.despriorizar(habito)),
          ),
        ],
      ),
    );
  }
}

// ---------- Pedaços visuais ----------

class _Banner extends StatelessWidget {
  const _Banner({required this.habito});

  final Habito habito;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.network(
            habito.imagemUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, erro, pilha) => Container(
              width: double.infinity,
              height: 200,
              color: cores.primaryContainer,
            ),
          ),
          // Degradê escuro embaixo, para o texto ficar legível
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              habito.nome,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoMeta extends StatelessWidget {
  const _CartaoMeta({required this.habito});

  final Habito habito;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(habito.icone, size: 32),
        title: const Text('Meta'),
        subtitle: Text(habito.meta),
      ),
    );
  }
}
