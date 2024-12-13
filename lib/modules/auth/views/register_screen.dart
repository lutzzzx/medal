import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
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
            TextField(
              controller: controller.confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            Obx(() => Row(
              children: [
                Checkbox(
                  value: controller.acceptTerms.value,
                  onChanged: (value) =>
                      controller.toggleAcceptTerms(value!),
                ),
                Text('I accept the Terms and Conditions'),
              ],
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.registerWithEmailPassword,
              child: Text('Register with Email'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: controller.registerWithGoogle,
              icon: Icon(Icons.login, color: Colors.white),
              label: Text('Register with Google'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            TextButton(
              onPressed: () => Get.offNamed('/login'),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
