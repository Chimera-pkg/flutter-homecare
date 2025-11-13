import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import 'sign_in_cubit.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    context.go(AppRoutes.home);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(AppRoutes.home); // Redirect to home
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go(AppRoutes.home); // Redirect to home
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) => SignInCubit(),
          child: BlocConsumer<SignInCubit, SignInState>(
            listener: (context, state) {
              if (state is SignInSuccess) {
                context.go(AppRoutes.dashboard);
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
                    backgroundColor: const Color(0xFF35C5CF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5.0,
                    side: BorderSide.none,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  onPressed: () {
                    String emailValue = emailController.text;
                    String passwordValue = passwordController.text;
                    context
                        .read<SignInCubit>()
                        .signIn(emailValue, passwordValue);
                  },
                  child: const Text('Sign In', style: TextStyle(fontSize: 18)),
                ),
              );

              final createAccountText = Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.signUp);
                  },
                  child: const Text(
                    'Create new account',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF35C5CF), // Turquoise green color
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
                        // Handle Google login
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF35C5CF), // Turquoise green color
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
      ),
    );
  }
}
