import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform,
	);
	runApp(const MyApp());
}

class MyApp extends StatefulWidget {
	const MyApp({super.key});

	@override
	State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	final _authService = AuthService();
	bool _showRegister = false;

	void _goRegister() => setState(() => _showRegister = true);
	void _goLogin() => setState(() => _showRegister = false);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter + Firebase Auth',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
			),
			home: StreamBuilder<User?>(
				stream: _authService.authStateChanges(),
				builder: (context, snapshot) {
					final user = snapshot.data;
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Scaffold(
							body: Center(child: CircularProgressIndicator()),
						);
					}
					if (user == null) {
						return _showRegister
							? RegisterPage(
								onGoLogin: _goLogin,
								onRegister: (name, email, password) async {
									await _authService.registerWithEmail(
										email: email,
										password: password,
										displayName: name,
									);
									_goLogin();
								},
							)
							: LoginPage(
								onGoRegister: _goRegister,
								onLogin: (email, password) async {
									await _authService.loginWithEmail(email: email, password: password);
								},
							);
					}
					return HomePage(onLogout: _authService.logout);
				},
			),
		);
	}
}
