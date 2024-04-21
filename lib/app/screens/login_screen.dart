import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nasari_test/app/services/api/auth_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController =
        TextEditingController(text: 'eve.holt@reqres.in');
    final TextEditingController passwordController =
        TextEditingController(text: 'cityslicka');

    final emailValidation = ValidationBuilder().required().build();
    final passwordValidation = ValidationBuilder().required().build();

    void showSnackbar(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    void login() async {
      final email = emailController.text;
      final password = passwordController.text;

      try {
        final response = await AuthApi.login(email, password);

        if (response.token != null) {
          var authBox = await Hive.openBox("auth");
          authBox.put("token", response.token);
          authBox.close();

          context.goNamed("home");
        }
      } catch (e) {
        showSnackbar("Login Failed");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                validator: emailValidation,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                validator: passwordValidation,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    login();
                    // context.replaceNamed("home");
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}
