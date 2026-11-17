# Lembretinhos 🎀

Diário de tarefinhas com lembretes, feito para o **Workshop Técnico (Tema 2: Notificações locais)**
da disciplina Laboratório de Desenvolvimento para Dispositivos Móveis, PUC Minas.

Cada tarefinha pode avisar na hora, daqui a um minuto ou todo dia no mesmo horário. Ao tocar na
notificação, o app abre direto na tarefinha que avisou.

O projeto roda **no Android e no Chrome**. No Chrome é só a prévia do layout: o pacote
`flutter_local_notifications` não existe na web, então os lembretes ficam desligados e o app avisa
isso num cartão amarelinho. **A demonstração da apresentação tem que ser no Android**, porque a
atividade exige dispositivo físico ou emulador.

## Integrantes

- Maria Luiza Manini de Oliveira
- Janielly Lorene Talinni dos Santos
- Sarah dos Santos Oliveira
- Davi Lucas Dias Morais
- Alex de Castro Mendes Marques

## Onde cada exigência do tema está no código

| Exigência | Onde está |
| --- | --- |
| Inicialização do plugin e canal Android | `Notificacoes.init` |
| Permissão (`POST_NOTIFICATIONS` no Android 13+, `requestPermissions` no iOS) | `Notificacoes.pedirPermissao` |
| Notificação imediata | `Notificacoes.lembrarAgora` |
| Notificação agendada com fuso horário | `Notificacoes.lembrarDepois` |
| Notificação recorrente | `Notificacoes.lembrarTodoDia` |
| Toque abre uma tela específica (payload) | `main.dart` e `dominio/payload.dart` |

## Estrutura

Organizado em camadas, como nas aulas:

```
lib/
  main.dart                       inicialização e navegação por payload
  dominio/
    tarefa.dart                   a classe Tarefa
    payload.dart                  formato e leitura do payload
  dados/
    tarefa_repositorio.dart       lista de tarefinhas (estado em memória)
    notificacoes.dart             toda a lógica de notificações
  ui/
    tela_lista.dart               lista de tarefinhas
    tela_tarefa.dart              tela da tarefinha e botões de lembrete
    tema.dart                     cores e estilo
    widgets/
      fundo_fofo.dart             fundo decorado
      cartao_tarefa.dart          cartão de uma tarefinha
      folha_nova_tarefa.dart      folha de adicionar tarefinha
test/payload_test.dart            testes do payload e do repositório
android_setup/                    manifesto e trecho do Gradle
```

## Requisitos

- Flutter 3.22 ou superior
- Para o Chrome: só o Flutter e o Chrome instalado
- Para o Android: o SDK do Android, mais um celular por cabo ou um emulador (API 33 ou superior)

## Como executar

Este repositório tem o código-fonte (`lib/`, `test/`, `pubspec.yaml`) e os ajustes de Android.
As pastas `android/`, `ios/` e `web/` são geradas pelo próprio Flutter.

**Passo 1 — gerar as pastas de plataforma**

```bash
git clone <URL-DO-REPOSITORIO>
cd lembretinhos
flutter create --project-name lembretinhos --org br.pucminas --platforms=android,ios,web .
```

O `flutter create` dentro de uma pasta que já tem `lib/` e `pubspec.yaml` não apaga nada: ele só
cria o que falta.

**Passo 2 — baixar as dependências**

```bash
flutter pub get
```

**Passo 3 — rodar no Chrome (opcional, só para ver o layout)**

```bash
flutter run -d chrome
```

Já funciona aqui. Os passos 4 e 5 são só para o Android.

**Passo 4 — trocar o manifesto**

Substitua `android/app/src/main/AndroidManifest.xml` pelo arquivo
`android_setup/AndroidManifest.xml`. Ele traz as permissões (`POST_NOTIFICATIONS`,
`RECEIVE_BOOT_COMPLETED`, `SCHEDULE_EXACT_ALARM`) e os dois receivers do plugin.

**Passo 5 — ajustar o Gradle**

Abra `android/app/build.gradle.kts` e aplique o trecho de
`android_setup/build.gradle.kts.trecho.txt`: desugaring, Java 11, `compileSdk 35` e
`multiDexEnabled`. Sem o desugaring o app nem compila, mesmo sem notificação agendada.

**Passo 6 — rodar no Android**

Com um celular no cabo (depuração USB ligada) ou com o emulador aberto:

```bash
flutter devices
flutter run
```

Para ligar o emulador sem abrir o Android Studio:

```bash
flutter emulators
flutter emulators --launch <nome-do-emulador>
```

### Se der erro

| Erro | O que fazer |
| --- | --- |
| `No supported devices connected` | Nenhum alvo conectado: use `-d chrome`, ligue o celular no cabo ou abra o emulador |
| `No such file or directory: android/` | Faltou o passo 1 |
| Algo sobre `desugar` ou `core library desugaring` | Faltou o passo 5 |
| Compila, mas nada aparece na tela de notificações | Permissão negada: toque em **ativar** no cartão rosa |
| A notificação agendada não chega no minuto | Permita alarmes exatos e desligue a economia de bateria |

### Por que a configuração do Android é necessária

- **Desugaring**: o plugin usa APIs de data e hora do Java que não existem em Androids antigos.
- **Receivers no manifesto**: `ScheduledNotificationReceiver` entrega a notificação agendada e
  `ScheduledNotificationBootReceiver` reagenda tudo quando o aparelho reinicia.
- **`SCHEDULE_EXACT_ALARM`**: permite entrega no minuto exato. Sem ela, o Android pode atrasar.

## Roteiro de teste (no Android)

1. Na tela inicial, toque em **ativar** no cartão de lembretes e aceite a permissão.
2. Toque em uma tarefinha para abrir a tela dela.
3. **Lembrar agora**: a notificação aparece na hora.
4. **Lembrar em 1 minuto**: pode bloquear a tela e esperar.
5. Toque na notificação: o app abre direto na tarefinha certa.
6. **Em 10 s (feche o app)**: feche o app por completo, espere e toque na notificação.
7. **Lembrar todo dia às 08:00**: mostra a notificação recorrente.
8. **Cancelar lembrete**, ou o link no fim da lista, para limpar tudo.

## Conceitos

- **Local vs. push**: a notificação local é criada e agendada pelo próprio aparelho, sem servidor
  e sem internet. A push chega de um servidor externo (por exemplo, o FCM).
- **Canal (Android 8+)**: agrupa notificações e guarda id, nome, importância e som. Depois de
  criado, o usuário controla o canal nas configurações do sistema.
- **Economia de bateria**: o modo Doze e as otimizações do fabricante podem adiar alarmes
  inexatos. Por isso o app usa agendamento exato quando o usuário permite.
- **Payload**: texto enviado junto com a notificação. Aqui é `tarefa/<id>`. Ao tocar, o app lê esse
  texto e abre a tarefinha certa. Com o app fechado, ele chega por
  `getNotificationAppLaunchDetails`.



## Detalhes que valem saber

- As tarefinhas ficam só na memória: ao fechar o app, a lista volta ao estado inicial. Isso mantém
  o foco no tema do workshop, e virar persistência é um dos desafios acima.
- O fuso local está fixo em `America/Sao_Paulo`. Em um app real, descubra o fuso do aparelho com
  um pacote como `flutter_timezone`.
- O pacote está fixado em `flutter_local_notifications ^19.5.0`, que funciona com Flutter 3.22 ou
  superior. As versões 20 e 21 trocaram vários parâmetros posicionais por nomeados e exigem um
  Flutter mais novo.
- O código tem os pontos de configuração do iOS, mas a demonstração foi feita no Android. Testar
  no iOS exige um Mac e, em aparelho físico, uma conta de desenvolvedor Apple.
