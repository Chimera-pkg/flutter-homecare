import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => SignInCubit(authRepository: sl()),
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              context.read<AuthCubit>().loggedIn();
            } else if (state is SignInError) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(state.message),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is SignInRequiresRole) {
              _showRoleSelectionDialog(context, state.idToken);
            }
          },
          builder: (context, state) {
            Hero(
              tag: 'logo',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: Image.asset('assets/icons/ic_launcher.png'),
              ),
            );

            final email = TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            );
            final password = TextFormField(
              controller: passwordController,
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            );

            final loginButton = Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.aqua,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                  side: BorderSide.none,
                  padding: const EdgeInsets.all(16.0),
                ),
                onPressed: () {
                  context
                      .read<SignInCubit>()
                      .signIn(emailController.text, passwordController.text);
                },
                child: const Text('Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            );

            final createAccountText = Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () {
                  context.go(AppRoutes.signUp);
                },
                child: const Text(
                  'Create new account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Const.aqua,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );

            const continueWithText = Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            );

            final socialIcons = Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('assets/icons/ic_fb.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Image.asset('assets/icons/ic_google.png'),
                    iconSize: 40,
                    onPressed: () {
                      context.read<SignInCubit>().signInWithGoogle();
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Image.asset('assets/icons/ic_wechat.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Handle WeChat login
                    },
                  ),
                ],
              ),
            );

            // final btnSignUp = Padding(
            //   padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.white,
            //       foregroundColor: Colors.blue,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30.0),
            //       ),
            //       elevation: 5.0,
            //       side: BorderSide.none,
            //       padding: EdgeInsets.all(12.0),
            //     ),
            //     onPressed: () {
            //       context.push(AppRoutes.signUp);
            //     },
            //     child: Text('Sign Up',
            //         style: TextStyle(fontSize: 18, color: Colors.blue)),
            //   ),
            // );

            return Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  const Text(
                    'Login Here',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Const.aqua, // Turquoise green color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Welcome Back you've\nbeen missed",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // if (state is SignInLoading)
                  //   CircularProgressIndicator()
                  // else
                  //   logo,
                  const SizedBox(height: 48.0),
                  email,
                  const SizedBox(height: 8.0),
                  password,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  loginButton,
                  const SizedBox(height: 11.0),
                  createAccountText,
                  continueWithText,
                  socialIcons,
                  // btnSignUp
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showRoleSelectionDialog(BuildContext context, String idToken) {
    final cubit = context.read<SignInCubit>();
    String selectedRole = 'patient';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Complete Registration',
              style: TextStyle(
                color: Const.aqua,
                fontWeight: FontWeight.w600,
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Welcome!\nPlease select your account type to continue.'),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select User Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                initialValue: selectedRole,
                items: <String>['Patient', 'Nurse', 'Pharmacist', 'Radiologist']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toLowerCase(),
                    child: Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Retry Google Auth with the selected role and cached token
                cubit.signInWithGoogle(role: selectedRole, idToken: idToken);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      }),
    );
  }
}
