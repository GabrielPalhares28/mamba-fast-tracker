import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _dailyCalorieGoalKey = 'daily_calorie_goal';

  final SharedPreferencesAsync _preferences =
      SharedPreferencesAsync();

  Future<int> loadDailyCalorieGoal() async {
    return await _preferences.getInt(_dailyCalorieGoalKey) ?? 2000;
  }

  Future<void> saveDailyCalorieGoal(int goal) async {
    await _preferences.setInt(
      _dailyCalorieGoalKey,
      goal,
    );
  }
}