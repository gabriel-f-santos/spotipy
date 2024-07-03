import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/theme/loader.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'signup_page.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          print('Logado com sucesso \n\n');
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Placeholder(),
          //   ),
          // );
        },
        error: (error, st) {
          showSnackBar(context, "Error");
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Signin.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                          hintText: 'Email', controller: _emailController),
                      const SizedBox(height: 15),
                      CustomField(
                          hintText: 'Password',
                          controller: _passwordController,
                          isObscureText: true),
                      const SizedBox(height: 20),
                      AuthGradientButton(
                          buttonText: 'Sign in',
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              {
                                await ref.read(authViewModelProvider.notifier).signin(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                              }
                            } else {
                              showSnackBar(context, 'Invalid form');
                            }
                          }),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Doesnt have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                text: 'Sign up.',
                                style: TextStyle(
                                  color: Pallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
