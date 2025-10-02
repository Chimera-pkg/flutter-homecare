import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';

class AuthenticationRequiredDialog extends StatelessWidget {
  const AuthenticationRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Authentication Required'),
      content: const Text(
        'Your session has expired or you are not logged in. Please sign in to continue.',
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Sign In'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            GoRouter.of(context).go(AppRoutes.signIn);
          },
        ),
      ],
    );
  }
}

void showAuthenticationRequiredDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AuthenticationRequiredDialog();
    },
  );
}
