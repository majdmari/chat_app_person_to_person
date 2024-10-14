import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/view/widget/custom_button.dart';
import 'package:chat_app/view/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function() onTap;
   const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

 void signIn()async{
// get the auth service
 final authService = Provider.of<AuthService>(context,listen: false);
 try {
   await authService.signInWithEmailAndPassword(
   emailController.text,
   passwordController.text,
   );
 }catch (e) {
   ScaffoldMessenger.of(context).showSnackBar(
   SnackBar(content: Text(e.toString())),

   );
 }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Icon(Icons.message,size: 80,color: Colors.grey[800],),
                SizedBox(height: 25),
                Text('Welcome back you have been missed!',style: TextStyle(
            fontSize: 16,
                ),),
                SizedBox(height: 25),
            CustomTextField(controller: emailController, hintText: 'Email', obscureText: false),
                SizedBox(height: 10),
            CustomTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                SizedBox(height: 25),
                CustomButton(text: 'Sign In', onTap: signIn),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap:  widget.onTap,
                      child: Text('Register now',style: TextStyle(
                        fontWeight: FontWeight.bold,

                      ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
