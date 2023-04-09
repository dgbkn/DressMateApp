import 'package:flutter/material.dart';
import 'package:dress_mate/components/my_button.dart';
import 'package:dress_mate/components/my_textfield.dart';
import 'package:dress_mate/components/square_tile.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
      
                // logo
                // const Icon(
                //   Icons.lock,
                //   size: 100,
                // ),

                // Image.asset("assets/logo.png",height: 50,),
                      Lottie.asset("assets/lottie_mate.json", height: 200),

                const SizedBox(height: 50),
      
                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
      
                const SizedBox(height: 25),
      
                // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username or email',
                  obscureText: false,
                ),
      
                const SizedBox(height: 10),
      
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
      
                const SizedBox(height: 10),
      
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 25),
      
                // sign in button
                MyButton(
                  onTap: signUserIn,
                ),
      
                const SizedBox(height: 50),
      
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 50),
      
                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    SquareTile(imagePath: 'assets/images/google.png'),
      
                    SizedBox(width: 30),
      
                    // apple button
                    SquareTile(imagePath: 'assets/images/apple.png'),
                  ],
                ),
      
                const SizedBox(height: 50),
      
                // not a member? register now
           
              ],
            ),
          ),
        ),
      ),
    );
  }
}