import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const LoginScreen({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _hasRegisteredUser = false;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final hasRegisteredUser =
        await _authService.hasRegisteredUser();

    if (!mounted) return;

    setState(() {
      _hasRegisteredUser = hasRegisteredUser;
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha e-mail e senha.';
      });

      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _errorMessage = 'Digite um e-mail válido.';
      });

      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage =
            'A senha deve ter pelo menos 6 caracteres.';
      });

      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    if (_hasRegisteredUser) {
      final success = await _authService.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (!success) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'E-mail ou senha incorretos.';
        });

        return;
      }
    } else {
      await _authService.register(
        email: email,
        password: password,
      );

      if (!mounted) return;
    }

    widget.onAuthenticated();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _hasRegisteredUser
              ? 'Entrar'
              : 'Criar conta',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _hasRegisteredUser
                    ? 'Bem-vindo de volta'
                    : 'Comece seu acompanhamento',
                style:
                    Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.email,
                ],
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                autofillHints: const [
                  AutofillHints.password,
                ],
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) {
                  if (!_isSubmitting) {
                    _submit();
                  }
                },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .error,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed:
                    _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _hasRegisteredUser
                            ? 'Entrar'
                            : 'Criar conta',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}