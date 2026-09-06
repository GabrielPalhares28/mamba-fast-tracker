import 'package:shared_preferences/shared_preferences.dart';

class FastingStorage {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const String _startTimeKey = 'fasting_start_time';
  static const String _endTimeKey = 'fasting_end_time';
  static const String _statusKey = 'fasting_status';
  static const String _pausedRemainingKey = 'paused_remaining_seconds';

  static const String _protocolNameKey = 'fasting_protocol_name';
  static const String _protocolFastingHoursKey =
      'fasting_protocol_fasting_hours';
  static const String _protocolEatingHoursKey =
      'fasting_protocol_eating_hours';

  Future<void> saveFastingState({
    required DateTime? startTime,
    required DateTime? endTime,
    required String status,
    required Duration? pausedRemainingTime,
    required String protocolName,
    required Duration protocolFastingDuration,
    required Duration protocolEatingDuration,
  }) async {
    if (startTime != null) {
      await _prefs.setString(
        _startTimeKey,
        startTime.toIso8601String(),
      );
    } else {
      await _prefs.remove(_startTimeKey);
    }

    if (endTime != null) {
      await _prefs.setString(
        _endTimeKey,
        endTime.toIso8601String(),
      );
    } else {
      await _prefs.remove(_endTimeKey);
    }

    await _prefs.setString(
      _statusKey,
      status,
    );

    if (pausedRemainingTime != null) {
      await _prefs.setInt(
        _pausedRemainingKey,
        pausedRemainingTime.inSeconds,
      );
    } else {
      await _prefs.remove(_pausedRemainingKey);
    }

    await _prefs.setString(
      _protocolNameKey,
      protocolName,
    );

    await _prefs.setInt(
      _protocolFastingHoursKey,
      protocolFastingDuration.inHours,
    );

    await _prefs.setInt(
      _protocolEatingHoursKey,
      protocolEatingDuration.inHours,
    );
  }

  Future<Map<String, dynamic>> loadFastingState() async {
    final startTimeString = await _prefs.getString(_startTimeKey);
    final endTimeString = await _prefs.getString(_endTimeKey);
    final status = await _prefs.getString(_statusKey);

    final pausedRemainingSeconds = await _prefs.getInt(
      _pausedRemainingKey,
    );

    final protocolName = await _prefs.getString(
      _protocolNameKey,
    );

    final protocolFastingHours = await _prefs.getInt(
      _protocolFastingHoursKey,
    );

    final protocolEatingHours = await _prefs.getInt(
      _protocolEatingHoursKey,
    );

    return {
      'startTime': startTimeString,
      'endTime': endTimeString,
      'status': status,
      'pausedRemainingSeconds': pausedRemainingSeconds,
      'protocolName': protocolName,
      'protocolFastingHours': protocolFastingHours,
      'protocolEatingHours': protocolEatingHours,
    };
  }
}