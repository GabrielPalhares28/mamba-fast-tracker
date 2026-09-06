import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _emailKey = 'auth_email';
  static const String _passwordHashKey = 'auth_password_hash';
  static const String _sessionKey = 'auth_session';

  final SharedPreferencesAsync _preferences =
      SharedPreferencesAsync();

  Future<bool> hasRegisteredUser() async {
    final email = await _preferences.getString(_emailKey);
    final passwordHash =
        await _preferences.getString(_passwordHashKey);

    return email != null && passwordHash != null;
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    final normalizedEmail =
        email.trim().toLowerCase();

    final passwordHash =
        _hashPassword(password);

    await _preferences.setString(
      _emailKey,
      normalizedEmail,
    );

    await _preferences.setString(
      _passwordHashKey,
      passwordHash,
    );

    await _preferences.setBool(
      _sessionKey,
      true,
    );
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final savedEmail =
        await _preferences.getString(_emailKey);

    final savedPasswordHash =
        await _preferences.getString(_passwordHashKey);

    if (savedEmail == null ||
        savedPasswordHash == null) {
      return false;
    }

    final normalizedEmail =
        email.trim().toLowerCase();

    final passwordHash =
        _hashPassword(password);

    final credentialsAreValid =
        normalizedEmail == savedEmail &&
        passwordHash == savedPasswordHash;

    if (credentialsAreValid) {
      await _preferences.setBool(
        _sessionKey,
        true,
      );
    }

    return credentialsAreValid;
  }

  Future<bool> isLoggedIn() async {
    return await _preferences.getBool(
          _sessionKey,
        ) ??
        false;
  }

  Future<void> logout() async {
    await _preferences.setBool(
      _sessionKey,
      false,
    );
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);

    return sha256.convert(bytes).toString();
  }
}