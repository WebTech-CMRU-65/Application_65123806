import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
	const RegisterPage({super.key, required this.onGoLogin, required this.onRegister});
	final VoidCallback onGoLogin;
	final Future<void> Function(String name, String email, String password) onRegister;

	@override
	State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
	final _formKey = GlobalKey<FormState>();
	final _nameCtrl = TextEditingController();
	final _emailCtrl = TextEditingController();
	final _passwordCtrl = TextEditingController();
	bool _loading = false;
	String? _error;

	@override
	void dispose() {
		_nameCtrl.dispose();
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
			await widget.onRegister(
				_nameCtrl.text.trim(),
				_emailCtrl.text.trim(),
				_passwordCtrl.text,
			);
		} catch (e) {
			setState(() => _error = e.toString());
		} finally {
			if (mounted) setState(() => _loading = false);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Register')),
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
										controller: _nameCtrl,
										decoration: const InputDecoration(labelText: 'ชื่อ-นามสกุล'),
										validator: (v) => v != null && v.isNotEmpty ? null : 'กรอกชื่อ',
									),
									const SizedBox(height: 12),
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
											: const Text('Create account'),
									),
									TextButton(
										onPressed: _loading ? null : widget.onGoLogin,
										child: const Text('Already have an account? Login'),
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
