const tarefaPrefix = 'tarefa/';

String tarefaPayload(int id) => '$tarefaPrefix$id';

int? parseTarefaId(String? payload) {
  if (payload == null || !payload.startsWith(tarefaPrefix)) return null;
  return int.tryParse(payload.substring(tarefaPrefix.length));
}
