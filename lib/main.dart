import 'dart:async';

import 'package:flutter/material.dart';

import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/history_screen.dart';
import 'database/app_database.dart';
import 'database/database_provider.dart';
import 'screens/meals_screen.dart';
import 'services/fasting_storage.dart';
import 'models/fasting_protocol.dart';
import 'widgets/protocol_selector.dart';
import 'widgets/fasting_schedule.dart';
import 'widgets/fasting_timer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();

  runApp(const MyApp());
}

enum FastingStatus { idle, fasting, paused, completed }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  void _handleAuthenticated() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mamba Fast Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: _isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _isLoggedIn
          ? HomePage(onLogout: _handleLogout)
          : LoginScreen(onAuthenticated: _handleAuthenticated),
    );
  }
}

class HomePage extends StatefulWidget {
  final Future<void> Function() onLogout;

  const HomePage({super.key, required this.onLogout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FastingStorage _storage = FastingStorage();

  FastingProtocol selectedProtocol = FastingProtocol.protocols[1];

  DateTime? fastingStartTime;
  DateTime? fastingEndTime;
  Duration? pausedRemainingTime;

  Timer? timer;

  FastingStatus fastingStatus = FastingStatus.idle;

  @override
  void initState() {
    super.initState();
    _restoreFastingState();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String get remainingTime {
    if (fastingStatus == FastingStatus.idle ||
        fastingStatus == FastingStatus.completed) {
      return _formatDuration(selectedProtocol.fastingDuration);
    }

    if (fastingStatus == FastingStatus.paused && pausedRemainingTime != null) {
      return _formatDuration(pausedRemainingTime!);
    }

    if (fastingEndTime == null) {
      return _formatDuration(selectedProtocol.fastingDuration);
    }

    final difference = fastingEndTime!.difference(DateTime.now());

    if (difference.isNegative) {
      return '00:00:00';
    }

    return _formatDuration(difference);
  }

  String get elapsedTime {
    if (fastingStatus == FastingStatus.idle ||
        fastingStatus == FastingStatus.completed) {
      return _formatDuration(Duration.zero);
    }

    Duration remaining;

    if (fastingStatus == FastingStatus.paused && pausedRemainingTime != null) {
      remaining = pausedRemainingTime!;
    } else if (fastingEndTime != null) {
      final difference = fastingEndTime!.difference(DateTime.now());

      remaining = difference.isNegative ? Duration.zero : difference;
    } else {
      remaining = selectedProtocol.fastingDuration;
    }

    final elapsed = selectedProtocol.fastingDuration - remaining;

    if (elapsed.isNegative) {
      return _formatDuration(Duration.zero);
    }

    return _formatDuration(elapsed);
  }

  String get buttonLabel {
    switch (fastingStatus) {
      case FastingStatus.idle:
        return 'Iniciar jejum';

      case FastingStatus.fasting:
        return 'Encerrar jejum';

      case FastingStatus.paused:
        return 'Retomar jejum';

      case FastingStatus.completed:
        return 'Iniciar jejum';
    }
  }

  IconData get buttonIcon {
    switch (fastingStatus) {
      case FastingStatus.idle:
        return Icons.play_arrow_rounded;

      case FastingStatus.fasting:
        return Icons.stop_rounded;

      case FastingStatus.paused:
        return Icons.play_arrow_rounded;

      case FastingStatus.completed:
        return Icons.play_arrow_rounded;
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) {
      return '--:--';
    }

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> _showCustomProtocolDialog() async {
    int fastingHours = 14;

    final selectedHours = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Protocolo personalizado'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              final eatingHours = 24 - fastingHours;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$fastingHours:$eatingHours',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: fastingHours.toDouble(),
                    min: 1,
                    max: 23,
                    divisions: 22,
                    label: '$fastingHours h',
                    onChanged: (value) {
                      setDialogState(() {
                        fastingHours = value.round();
                      });
                    },
                  ),
                  Text(
                    '$fastingHours h de jejum • '
                    '$eatingHours h de alimentação',
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, fastingHours);
              },
              child: const Text('Usar protocolo'),
            ),
          ],
        );
      },
    );

    if (selectedHours == null || !mounted) {
      return;
    }

    setState(() {
      selectedProtocol = FastingProtocol.custom(selectedHours);
    });
  }

  Future<void> _saveCurrentState() {
    return _storage.saveFastingState(
      startTime: fastingStartTime,
      endTime: fastingEndTime,
      status: fastingStatus.name,
      pausedRemainingTime: pausedRemainingTime,
      protocolName: selectedProtocol.name,
      protocolFastingDuration: selectedProtocol.fastingDuration,
      protocolEatingDuration: selectedProtocol.eatingDuration,
    );
  }

  Future<void> _restoreFastingState() async {
    final savedState = await _storage.loadFastingState();

    final startTimeString = savedState['startTime'] as String?;
    final endTimeString = savedState['endTime'] as String?;
    final statusString = savedState['status'] as String?;

    final pausedRemainingSeconds = savedState['pausedRemainingSeconds'] as int?;

    final protocolName = savedState['protocolName'] as String?;
    final protocolFastingHours = savedState['protocolFastingHours'] as int?;
    final protocolEatingHours = savedState['protocolEatingHours'] as int?;

    final restoredStartTime = startTimeString != null
        ? DateTime.parse(startTimeString)
        : null;

    final restoredEndTime = endTimeString != null
        ? DateTime.parse(endTimeString)
        : null;

    final restoredStatus = FastingStatus.values.firstWhere(
      (status) => status.name == statusString,
      orElse: () => FastingStatus.idle,
    );

    final restoredPausedRemainingTime = pausedRemainingSeconds != null
        ? Duration(seconds: pausedRemainingSeconds)
        : null;

    FastingProtocol? restoredProtocol;

    if (protocolName != null &&
        protocolFastingHours != null &&
        protocolEatingHours != null) {
      restoredProtocol = FastingProtocol(
        name: protocolName,
        fastingDuration: Duration(hours: protocolFastingHours),
        eatingDuration: Duration(hours: protocolEatingHours),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      fastingStartTime = restoredStartTime;
      fastingEndTime = restoredEndTime;
      pausedRemainingTime = restoredPausedRemainingTime;
      fastingStatus = restoredStatus;

      if (restoredProtocol != null) {
        selectedProtocol = restoredProtocol;
      }
    });

    if (fastingStatus == FastingStatus.fasting) {
      final endTime = fastingEndTime;

      if (endTime != null && endTime.isAfter(DateTime.now())) {
        _startTimer();
      } else if (endTime != null) {
        await _saveFastingSession(
          endedAt: endTime,
          actualDurationMinutes: selectedProtocol.fastingDuration.inMinutes,
        );

        setState(() {
          pausedRemainingTime = null;
          fastingStatus = FastingStatus.completed;
        });

        await _saveCurrentState();
      }
    }
  }

  void _startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final endTime = fastingEndTime;

      if (endTime == null) {
        timer.cancel();
        return;
      }

      final difference = endTime.difference(DateTime.now());

      if (difference.isNegative || difference.inSeconds == 0) {
        timer.cancel();

        setState(() {
          pausedRemainingTime = null;
          fastingStatus = FastingStatus.completed;
        });

        _saveFastingSession(
          endedAt: endTime,
          actualDurationMinutes: selectedProtocol.fastingDuration.inMinutes,
        );

        _saveCurrentState();

        return;
      }

      setState(() {});
    });
  }

  Future<void> _startFasting() async {
    final now = DateTime.now();

    setState(() {
      fastingStartTime = now;
      fastingEndTime = now.add(selectedProtocol.fastingDuration);
      pausedRemainingTime = null;
      fastingStatus = FastingStatus.fasting;
    });

    await _saveCurrentState();

    await NotificationService.requestPermission();

    await NotificationService.showFastingStartedNotification();

    final endTime = fastingEndTime;

    if (endTime != null) {
      await NotificationService.scheduleFastingEndedNotification(endTime);
    }

    _startTimer();
  }

  Future<void> _pauseFasting() async {
    final endTime = fastingEndTime;

    if (endTime == null) {
      return;
    }

    timer?.cancel();

    setState(() {
      pausedRemainingTime = endTime.difference(DateTime.now());
      fastingStatus = FastingStatus.paused;
    });

    await NotificationService.cancelFastingEndedNotification();
    await _saveCurrentState();
  }

  Future<void> _resumeFasting() async {
    final remaining = pausedRemainingTime;

    if (remaining == null) {
      return;
    }

    final now = DateTime.now();

    setState(() {
      fastingEndTime = now.add(remaining);
      pausedRemainingTime = null;
      fastingStatus = FastingStatus.fasting;
    });

    final endTime = fastingEndTime;

    if (endTime != null) {
      await NotificationService.scheduleFastingEndedNotification(endTime);
    }

    await _saveCurrentState();
    _startTimer();
  }

  Future<void> _saveFastingSession({
    required DateTime endedAt,
    required int actualDurationMinutes,
  }) async {
    await database.addFastingSession(
      FastingSessionsCompanion.insert(
        protocolName: selectedProtocol.name,
        startedAt: fastingStartTime ?? endedAt,
        endedAt: endedAt,
        plannedDurationMinutes: selectedProtocol.fastingDuration.inMinutes,
        actualDurationMinutes: actualDurationMinutes,
      ),
    );

    debugPrint('Sessão de jejum salva no banco!');
  }

  Future<void> _endFasting() async {
    timer?.cancel();

    final endedAt = DateTime.now();

    final remainingDuration = fastingEndTime != null
        ? fastingEndTime!.difference(endedAt)
        : Duration.zero;

    final safeRemainingDuration = remainingDuration.isNegative
        ? Duration.zero
        : remainingDuration;

    final actualDuration =
        selectedProtocol.fastingDuration - safeRemainingDuration;

    final actualDurationMinutes = actualDuration.isNegative
        ? 0
        : actualDuration.inMinutes;

    setState(() {
      fastingEndTime = endedAt;
      pausedRemainingTime = null;
      fastingStatus = FastingStatus.completed;
    });

    await NotificationService.cancelFastingEndedNotification();

    await _saveFastingSession(
      endedAt: endedAt,
      actualDurationMinutes: actualDurationMinutes,
    );

    await _saveCurrentState();
  }

  void _handleFastingButton() {
    switch (fastingStatus) {
      case FastingStatus.idle:
        _startFasting();
        break;

      case FastingStatus.fasting:
        _endFasting();
        break;

      case FastingStatus.paused:
        _resumeFasting();
        break;

      case FastingStatus.completed:
        _startFasting();
        break;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mamba Fast Tracker'),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            tooltip: 'Sair',
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seu jejum',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Protocolo ${selectedProtocol.name}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),

              ProtocolSelector(
                selectedProtocol: selectedProtocol,
                enabled:
                    fastingStatus == FastingStatus.idle ||
                    fastingStatus == FastingStatus.completed,
                onProtocolSelected: (protocol) {
                  setState(() {
                    selectedProtocol = protocol;
                  });
                },
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed:
                      fastingStatus == FastingStatus.idle ||
                          fastingStatus == FastingStatus.completed
                      ? _showCustomProtocolDialog
                      : null,
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Personalizado'),
                ),
              ),
              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MealsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.restaurant),
                label: const Text('Refeições'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('Histórico'),
              ),
              const SizedBox(height: 48),

              FastingTimer(remainingTime: remainingTime),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Decorrido: $elapsedTime',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 32),

              FastingSchedule(
                startTime: _formatTime(fastingStartTime),
                endTime: _formatTime(fastingEndTime),
              ),

              const SizedBox(height: 32),

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _handleFastingButton,
                      icon: Icon(buttonIcon),
                      label: Text(buttonLabel),
                    ),
                  ),
                  if (fastingStatus == FastingStatus.fasting) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pauseFasting,
                        icon: const Icon(Icons.pause_rounded),
                        label: const Text('Pausar jejum'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
