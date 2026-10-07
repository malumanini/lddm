import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diario_de_habitos1/dominio/habito.dart';
import 'package:diario_de_habitos1/dominio/habitos_store.dart';

class TelaDetalhe extends StatelessWidget {
  const TelaDetalhe({super.key, required this.habito});

  final Habito habito;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(habito.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir hábito',
            onPressed: () async {
              await context.read<HabitosStore>().remover(habito);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.network(
                  habito.imagemUrl,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (context, erro, pilha) => Container(
                    width: double.infinity,
                    height: 190,
                    color: cores.primaryContainer,
                  ),
                  loadingBuilder: (context, filho, progresso) =>
                      progresso == null
                      ? filho
                      : SizedBox(
                          height: 190,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: cores.primary,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          cores.scrim.withOpacity(0.0),
                          cores.scrim.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 88,
                  right: 16,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habito.nome,
                        style: textos.titleLarge?.copyWith(
                          color: cores.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        habito.meta,
                        style: textos.bodyMedium?.copyWith(
                          color: cores.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: -28,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: cores.surface,
                    child: Icon(habito.icone, color: cores.primary, size: 28),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _Indicador(
                      icone: Icons.calendar_today,
                      valor: '12',
                      rotulo: 'dias seguidos',
                      cores: cores,
                      textos: textos,
                    ),
                  ),
                  Expanded(
                    child: _Indicador(
                      icone: Icons.local_drink,
                      valor: '6/8',
                      rotulo: 'copos hoje',
                      cores: cores,
                      textos: textos,
                    ),
                  ),
                  Expanded(
                    child: _Indicador(
                      icone: Icons.trending_up,
                      valor: '86%',
                      rotulo: 'na semana',
                      cores: cores,
                      textos: textos,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: cores.surfaceContainerHigh,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sobre este hábito',
                        style: textos.titleMedium?.copyWith(
                          color: cores.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manter-se hidratado ao longo do dia ajuda na concentração, '
                        'na disposição e no funcionamento do corpo.',
                        style: textos.bodyMedium?.copyWith(
                          color: cores.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await context.read<HabitosStore>().priorizar(habito);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Priorizar'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  const _Indicador({
    required this.icone,
    required this.valor,
    required this.rotulo,
    required this.cores,
    required this.textos,
  });

  final IconData icone;
  final String valor;
  final String rotulo;
  final ColorScheme cores;
  final TextTheme textos;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    decoration: BoxDecoration(
      color: cores.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Icon(icone, color: cores.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          valor,
          style: textos.headlineSmall?.copyWith(
            color: cores.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          rotulo,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textos.bodySmall?.copyWith(color: cores.onSurfaceVariant),
        ),
      ],
    ),
  );
}
