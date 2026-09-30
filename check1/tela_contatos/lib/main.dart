import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contatos',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const TelaContatos(),
    );
  }
}

class Contato {
  final IconData icone;
  final String nome;
  final String cidade;
  final String telefone;

  const Contato({
    required this.icone,
    required this.nome,
    required this.cidade,
    required this.telefone,
  });
}

class TelaContatos extends StatefulWidget {
  const TelaContatos({super.key});

  @override
  State<TelaContatos> createState() => _TelaContatosState();
}

class _TelaContatosState extends State<TelaContatos> {
  final List<Contato> _contatos = const [
    Contato(
      icone: Icons.person,
      nome: 'Thayná Cota',
      cidade: 'Belo Horizonte',
      telefone: '(31) 99999-1111',
    ),
    Contato(
      icone: Icons.person,
      nome: 'Malu Manini',
      cidade: 'São Paulo',
      telefone: '(11) 98888-2222',
    ),
    Contato(
      icone: Icons.person,
      nome: 'Leticia Beatriz',
      cidade: 'Rio de Janeiro',
      telefone: '(21) 97777-3333',
    ),
  ];

  int get _total => _contatos.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              'Total de contatos: $_total',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _contatos.length,
              separatorBuilder: (context, i) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final c = _contatos[i];
                return ListTile(
                  leading: Icon(c.icone),
                  title: Text(c.nome),
                  subtitle: Text('${c.cidade} · ${c.telefone}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
