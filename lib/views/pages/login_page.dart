import 'package:flutter/material.dart';
import 'package:Kleme/views/widget_tree.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Kleme",
                    style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 51, 113, 78),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 400,
              height: 400,
              margin: const EdgeInsets.only(top: 25),
              child: Lottie.asset('assets/lotties/Coffee_Red.json'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 113, 78),
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      "Choose your preferred way to continue",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 22),

                    _buildLoginButton(
                      icon: Icons.facebook,
                      text: "Facebook",
                      backgroundColor: const Color(0xff1877F2),
                      textColor: Colors.white,
                      context: context,
                    ),

                    const SizedBox(height: 10),
                    _buildLoginButton(
                      icon: Icons.apple,
                      text: "Apple",
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      context: context,
                    ),

                    const SizedBox(height: 20),
                    const Divider(),

                    const SizedBox(height: 20),

                    _buildLoginButton(
                      icon: Icons.email_outlined,
                      text: "Email",
                      backgroundColor: Color.fromARGB(255, 51, 113, 78),
                      textColor: Colors.white,
                      context: context,
                    ),

                    const SizedBox(height: 12),

                    _buildLoginButton(
                      icon: Icons.phone_outlined,
                      text: "Phone",
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      border: BorderSide(color: Colors.black, width: 1),
                      context: context,
                    ),

                    const SizedBox(height: 18),

                    const Text.rich(
                      TextSpan(
                        text: "Registering means you agree to our ",
                        style: TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                            text: "Terms of Use and Privacy Policy",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color.fromARGB(255, 51, 113, 78),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required IconData icon,
    required String text,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
    BorderSide? border,
    required BuildContext context,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WidgetTree()),
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 16, color: textColor)),
          ],
        ),
      ),
    );
  }
}
