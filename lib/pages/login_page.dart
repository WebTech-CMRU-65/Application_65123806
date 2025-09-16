import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
	const LoginPage({super.key, required this.onGoRegister, required this.onLogin});
	final VoidCallback onGoRegister;
	final Future<void> Function(String email, String password) onLogin;

	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final _formKey = GlobalKey<FormState>();
	final _emailCtrl = TextEditingController();
	final _passwordCtrl = TextEditingController();
	bool _loading = false;
	String? _error;

	@override
	void dispose() {
		_emailCtrl.dispose();
		_passwordCtrl.dispose();
		super.dispose();
	}

	Future<void> _onSubmit() async {
		if (!_formKey.currentState!.validate()) return;
		setState(() {
			_loading = true;
			_error = null;
		});
		try {
			await widget.onLogin(_emailCtrl.text.trim(), _passwordCtrl.text);
		} catch (e) {
			setState(() => _error = e.toString());
		} finally {
			if (mounted) setState(() => _loading = false);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Login')),
			body: Center(
				child: ConstrainedBox(
					constraints: const BoxConstraints(maxWidth: 420),
					child: Padding(
						padding: const EdgeInsets.all(16),
						child: Form(
							key: _formKey,
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									TextFormField(
										controller: _emailCtrl,
										decoration: const InputDecoration(labelText: 'Email'),
										keyboardType: TextInputType.emailAddress,
										validator: (v) => v != null && v.contains('@') ? null : 'Email ไม่ถูกต้อง',
									),
									const SizedBox(height: 12),
									TextFormField(
										controller: _passwordCtrl,
										decoration: const InputDecoration(labelText: 'Password'),
										obscureText: true,
										validator: (v) => v != null && v.length >= 6 ? null : 'อย่างน้อย 6 ตัวอักษร',
									),
									const SizedBox(height: 16),
									if (_error != null) ...[
										Text(_error!, style: const TextStyle(color: Colors.red)),
										const SizedBox(height: 8),
									],
									FilledButton(
										onPressed: _loading ? null : _onSubmit,
										child: _loading
											? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
											: const Text('Login'),
									),
									TextButton(
										onPressed: _loading ? null : widget.onGoRegister,
										child: const Text('Create an account'),
									)
								],
							),
						),
					),
				),
			),
		);
	}
}
