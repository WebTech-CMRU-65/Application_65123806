import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
	const HomePage({super.key, required this.onLogout});
	final Future<void> Function() onLogout;

	@override
	Widget build(BuildContext context) {
		final user = FirebaseAuth.instance.currentUser;
		return Scaffold(
			appBar: AppBar(
				title: const Text('Home'),
				actions: [
					IconButton(
						icon: const Icon(Icons.logout),
						onPressed: () async {
							await onLogout();
						},
					),
				],
			),
			body: Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						const Icon(Icons.verified_user, size: 48, color: Colors.green),
						const SizedBox(height: 12),
						Text('UID: ${user?.uid ?? '-'}'),
						Text('Email: ${user?.email ?? '-'}'),
					],
				),
			),
		);
	}
}
