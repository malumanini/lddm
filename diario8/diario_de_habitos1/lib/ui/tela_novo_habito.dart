import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diario_de_habitos1/dominio/habito.dart';
import 'package:diario_de_habitos1/dominio/habitos_store.dart';

class TelaNovoHabito extends StatefulWidget {
  const TelaNovoHabito({super.key});

  @override
  State<TelaNovoHabito> createState() => _TelaNovoHabitoState();
}

class _TelaNovoHabitoState extends State<TelaNovoHabito> {
  static const _imagemPadrao =
      'https://images.pexels.com/photos/336407/pexels-photo-336407.jpeg?auto=compress&cs=tinysrgb&w=1200';

  static const _icones = <IconData>[
    Icons.local_drink,
    Icons.menu_book,
    Icons.directions_walk,
    Icons.bedtime,
    Icons.fitness_center,
    Icons.self_improvement,
  ];

  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _meta = TextEditingController();
  IconData _icone = _icones.first;

  @override
  void dispose() {
    _nome.dispose();
    _meta.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    // Sem id: quem gera o id é o banco.
    final habito = Habito(
      nome: _nome.text.trim(),
      meta: _meta.text.trim(),
      icone: _icone,
      imagemUrl: _imagemPadrao,
    );

    await context.read<HabitosStore>().adicionar(habito);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo hábito')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _meta,
              decoration: const InputDecoration(
                labelText: 'Meta',
                hintText: 'Ex.: 20 páginas por dia',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe a meta' : null,
            ),
            const SizedBox(height: 24),
            Text('Ícone', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final icone in _icones)
                  ChoiceChip(
                    label: Icon(icone),
                    selected: _icone == icone,
                    onSelected: (_) => setState(() => _icone = icone),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(onPressed: _salvar, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
