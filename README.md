# Mamba Fast Tracker

Aplicativo mobile desenvolvido em Flutter para acompanhamento de jejum intermitente, consumo diário de calorias e histórico semanal.

O projeto foi criado como desafio técnico e prioriza funcionamento offline, persistência local, simplicidade de uso e recuperação correta do estado do jejum mesmo após o aplicativo ser fechado e aberto novamente.

## Funcionalidades

- Autenticação local com e-mail e senha.
- Persistência da sessão do usuário.
- Protocolos de jejum predefinidos: 12:12, 16:8 e 18:6.
- Protocolo personalizado.
- Início, pausa, retomada e encerramento de jejum.
- Cálculo de tempo restante e tempo decorrido.
- Recuperação do estado do timer após background ou reabertura do aplicativo.
- Notificações de início e conclusão do jejum.
- Cadastro, edição e exclusão de refeições.
- Registro de nome, calorias e horário da refeição.
- Meta diária configurável de calorias.
- Indicador de consumo dentro ou acima da meta.
- Histórico dos últimos dias com calorias consumidas e tempo de jejum.
- Gráfico semanal de calorias.
- Persistência local dos dados.

## Tecnologias utilizadas

- Flutter
- Dart
- Drift / SQLite
- SharedPreferences
- flutter_local_notifications
- timezone / flutter_timezone
- fl_chart
- crypto

As dependências utilizadas no projeto estão definidas em `pubspec.yaml`.

## Decisões técnicas

### Timer baseado em timestamps

O contador de jejum não depende apenas de um valor decrementado em memória. O aplicativo persiste os horários de início e término e recalcula o tempo restante a partir do relógio do dispositivo.

Essa abordagem permite reconstruir corretamente o estado do jejum quando o aplicativo passa tempo em background ou é fechado e aberto novamente.

### Persistência local

O Drift, sobre SQLite, é utilizado para dados estruturados como refeições e sessões de jejum.

O SharedPreferences é utilizado para preferências e estados leves, como sessão local, protocolo selecionado, estado atual do timer e meta diária de calorias.

### Notificações

O aplicativo utiliza notificações locais para informar quando um jejum é iniciado e quando o período programado termina. A notificação de término é reagendada ou cancelada conforme o usuário pausa, retoma ou encerra o jejum.

### Autenticação

A autenticação deste projeto é local e foi implementada para atender ao escopo do desafio técnico. A senha não é armazenada em texto puro: é persistido um hash SHA-256.

Em um ambiente de produção, a autenticação deveria ser delegada a um serviço apropriado, como Firebase Authentication ou backend próprio, juntamente com armazenamento seguro e políticas adequadas de gerenciamento de credenciais.

## Estrutura principal

```text
lib/
├── database/     # Banco local, tabelas e acesso aos dados
├── models/       # Modelos de domínio
├── screens/      # Telas da aplicação
├── services/     # Persistência, autenticação e notificações
├── widgets/      # Componentes reutilizáveis
└── main.dart     # Inicialização e fluxo principal
```

## Como executar

### Pré-requisitos

- Flutter SDK instalado
- Android SDK configurado
- Dispositivo Android físico ou emulador

### Instalação

```bash
git clone https://github.com/GabrielPalhares28/mamba-fast-tracker.git
cd mamba-fast-tracker
flutter pub get
flutter run
```

Caso seja necessário regenerar os arquivos do Drift:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Gerando o APK de release

```bash
flutter build apk --release
```

O arquivo será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## APK

A versão de release pode ser disponibilizada na seção **Releases** deste repositório:

https://github.com/GabrielPalhares28/mamba-fast-tracker/releases

## Validação

O aplicativo foi executado e validado em dispositivo Android físico, incluindo:

- criação e persistência de sessão;
- início, pausa, retomada e encerramento de jejum;
- recuperação do timer após fechar e reabrir o aplicativo;
- notificações locais;
- CRUD de refeições;
- persistência da meta calórica;
- histórico e gráfico semanal;
- geração e instalação de APK em modo release.

## Observações

O projeto foi desenvolvido com foco no MVP solicitado no desafio técnico. As escolhas priorizam clareza, previsibilidade e funcionamento offline, evitando dependências ou complexidade arquitetural que não fossem necessárias para o escopo proposto.
