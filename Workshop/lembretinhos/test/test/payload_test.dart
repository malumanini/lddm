import 'package:flutter_test/flutter_test.dart';
import 'package:lembretinhos/dados/tarefa_repositorio.dart';
import 'package:lembretinhos/dominio/payload.dart';

void main() {
  test('payload da tarefa faz ida e volta', () {
    expect(parseTarefaId(tarefaPayload(7)), 7);
  });

  test('payload desconhecido é ignorado', () {
    expect(parseTarefaId(null), isNull);
    expect(parseTarefaId('outra/1'), isNull);
    expect(parseTarefaId('tarefa/abc'), isNull);
  });

  test('repositório acha a tarefa pelo id', () {
    expect(TarefaRepositorio.instance.byId(1), isNotNull);
    expect(TarefaRepositorio.instance.byId(999), isNull);
  });
}
