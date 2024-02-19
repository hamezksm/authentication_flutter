// ignore_for_file: avoid_print

import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthenticationPage(),
    );
  }
}

class AuthenticationPage extends StatelessWidget {
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Check if biometrics are available
            bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
            print(canCheckBiometrics);

            if (canCheckBiometrics) {
              // Attempt biometric authentication
              bool authenticated = await _authenticateWithBiometrics();

              if (authenticated) {
                // User successfully authenticated with biometrics
                _navigateToNextScreen();
              }
            }
          },
          child: const Text('Authenticate'),
        ),
      ),
    );
  }

  Future<bool> _authenticateWithBiometrics() async {
    bool authenticated = false;

    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Input fingerprint to authenticate',
        // useErrorDialogs: true,
        // stickyAuth: true,
      );
    } catch (e) {
      print('Error authenticating with biometrics: $e');
    }

    return authenticated;
  }

  void _showPinPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter PIN or Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                // Add controller to handle user input
                obscureText: true, // Hide PIN characters
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your PIN',
                ),
              ),
              const SizedBox(
                  height: 16), // Add some space between PIN and password fields
              TextFormField(
                // Add controller to handle user input
                obscureText: true, // Hide password characters
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  hintText: 'Enter your Password',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Verify PIN/Password and grant access if valid
                // Replace this with your logic to verify PIN/Password
                _navigateToNextScreen();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToNextScreen() {
    // Navigate to the next screen
  }
}
