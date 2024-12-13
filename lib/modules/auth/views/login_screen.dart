import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.login,
              child: Text('Login'),
            ),
            ElevatedButton.icon(
              onPressed: controller.loginWithGoogle,
              icon: Icon(Icons.login, color: Colors.white),
              label: Text('Login with Google'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            TextButton(
              onPressed: () => Get.offNamed('/register'),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
