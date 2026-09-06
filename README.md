# Mamba Fast Tracker

Aplicativo mobile desenvolvido em Flutter para acompanhamento de jejum intermitente, consumo diário de calorias e histórico semanal.

O projeto foi criado como desafio técnico para a Mamba Growth e prioriza funcionamento offline, persistência local, simplicidade de uso e recuperação correta do estado do jejum mesmo após o aplicativo ser colocado em background ou fechado e aberto novamente.

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
- Registro de nome, calorias e horário automático da refeição.
- Meta diária configurável de calorias.
- Indicador de consumo dentro ou acima da meta.
- Histórico dos últimos dias com calorias consumidas e tempo de jejum.
- Gráfico semanal de calorias.
- Persistência local dos dados.
- Suporte ao tema claro/escuro conforme configuração do sistema.

## Stack escolhida

- Flutter / Dart
- Drift / SQLite
- SharedPreferences

Flutter foi utilizado conforme a stack definida para o desafio. O Drift/SQLite foi escolhido para os dados estruturados da aplicação e o SharedPreferences para estados e preferências leves.

## Arquitetura utilizada

O projeto utiliza uma organização em camadas simples, adequada ao tamanho do MVP, separando responsabilidades entre interface, modelos, persistência e serviços.

```text
lib/
├── database/     # Banco local, tabelas e acesso aos dados
├── models/       # Modelos de domínio
├── screens/      # Telas e composição dos fluxos da aplicação
├── services/     # Autenticação, persistência de estado e notificações
├── widgets/      # Componentes visuais reutilizáveis
└── main.dart     # Inicialização, sessão e fluxo principal do jejum
```

A opção foi manter uma arquitetura direta e legível em vez de introduzir Bloc, Redux ou uma implementação completa de Clean Architecture apenas para aumentar a quantidade de camadas. Para o escopo e prazo do desafio, isso reduz complexidade acidental sem misturar persistência estruturada, serviços e componentes visuais.

## Decisões técnicas

### Timer baseado em timestamps

O contador de jejum não depende apenas de um valor decrementado em memória. O aplicativo persiste os horários de início e término e recalcula o tempo restante a partir do relógio do dispositivo.

Essa abordagem torna o timer menos dependente do ciclo de vida da interface e permite reconstruir corretamente o estado quando o aplicativo passa tempo em background ou é fechado e aberto novamente.

### Persistência local e funcionamento offline

O Drift, sobre SQLite, é utilizado para dados estruturados, como refeições e sessões de jejum. O SharedPreferences é utilizado para preferências e estados leves, como sessão local, protocolo selecionado, estado atual do timer e meta diária de calorias.

Como o MVP não depende de backend, as funcionalidades principais continuam disponíveis localmente.

### Notificações

O aplicativo utiliza notificações locais para informar quando um jejum é iniciado e quando o período programado termina. A notificação de término é reagendada ou cancelada conforme o usuário pausa, retoma ou encerra o jejum.

### Autenticação

A autenticação é local e foi implementada para atender ao escopo do desafio. A senha não é armazenada em texto puro: é persistido um hash SHA-256.

Em produção, a autenticação deveria ser delegada a um serviço apropriado, como Firebase Authentication ou backend próprio, juntamente com armazenamento seguro e políticas adequadas de gerenciamento de credenciais.

## Bibliotecas utilizadas

- `drift` / `drift_flutter` — persistência estruturada sobre SQLite.
- `shared_preferences` — sessão, preferências e estado leve do aplicativo.
- `flutter_local_notifications` — notificações locais do jejum.
- `timezone` / `flutter_timezone` — agendamento das notificações considerando o fuso do dispositivo.
- `fl_chart` — gráfico semanal de calorias.
- `crypto` — hash utilizado na autenticação local do MVP.
- `drift_dev` / `build_runner` — geração de código do Drift durante o desenvolvimento.
- `flutter_launcher_icons` — geração dos ícones Android a partir do asset do projeto.

As versões utilizadas estão registradas em `pubspec.yaml` e `pubspec.lock`.

## Trade-offs considerados

- **Autenticação local em vez de Firebase:** reduz configuração e dependência de serviços externos dentro do prazo, mas não representa a solução de autenticação que seria utilizada em produção.
- **SharedPreferences para estado leve:** é suficiente para preferências, sessão e reconstrução do timer neste MVP; dados estruturados e históricos ficam no SQLite por meio do Drift.
- **Arquitetura simples em vez de Bloc/Clean Architecture completa:** favorece velocidade de entrega e legibilidade para o tamanho atual do produto, ao custo de exigir uma evolução da camada de estado caso o aplicativo cresça significativamente.
- **Notificações locais:** atendem ao fluxo de jejum sem backend ou push remoto. Uma solução de produto maior poderia combinar notificações locais com serviços remotos conforme a necessidade.
- **Persistência offline/local:** oferece uso independente de conexão, mas não inclui sincronização entre dispositivos ou backup em nuvem.

## O que melhoraria com mais tempo

Em uma evolução do produto, os próximos passos seriam:

- migrar a autenticação para Firebase Authentication ou backend próprio com armazenamento seguro de credenciais;
- ampliar a separação de estado e regras de negócio conforme o crescimento do aplicativo;
- adicionar testes unitários e de widgets para os fluxos críticos, especialmente timer, persistência e agregações diárias;
- adicionar CI para análise, testes e geração de builds;
- implementar sincronização/backup em nuvem;
- ampliar métricas, gráficos e acompanhamento de metas;
- realizar uma rodada adicional de acessibilidade, testes em diferentes versões/dispositivos Android e refinamento de UX.

## Tempo gasto no desafio

O desenvolvimento foi realizado ao longo de aproximadamente **3 dias corridos**, incluindo planejamento, implementação do MVP, testes em dispositivo físico, correções, documentação, polimento visual e geração do build Android.

## Como rodar o projeto

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

O build final do desafio foi gerado com sucesso em modo release, com aproximadamente **56 MB**.

## APK / link para execução

O APK Android será disponibilizado na seção **Releases** deste repositório:

https://github.com/GabrielPalhares28/mamba-fast-tracker/releases

Para executar sem configurar o ambiente Flutter, basta baixar o APK da release e instalá-lo em um dispositivo Android. Como se trata de um APK distribuído fora da Play Store, o Android pode solicitar autorização para instalar aplicativos provenientes dessa fonte.

## Validação

O aplicativo foi executado e validado em dispositivo Android físico, incluindo:

- criação, login, logout e persistência de sessão;
- início, pausa, retomada e encerramento de jejum;
- recuperação do timer após fechar e reabrir o aplicativo;
- conclusão de jejum e persistência no histórico;
- notificações locais de início e término;
- CRUD de refeições;
- persistência e alteração da meta calórica;
- histórico e gráfico semanal;
- geração, instalação e execução do APK em modo release.

Antes da entrega, o projeto também foi validado com `flutter analyze` sem issues.

## Observações

O projeto foi desenvolvido com foco no MVP solicitado no desafio técnico. As escolhas priorizam clareza, previsibilidade, funcionamento offline e entrega dentro do prazo, evitando complexidade arquitetural que não trouxesse benefício proporcional ao escopo atual.
