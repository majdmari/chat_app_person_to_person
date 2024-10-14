import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../widget/custom_button.dart';
import '../widget/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

   void signUp()async{
      if (passwordController.text != confirmPasswordController.text) {
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Passwords do not match'),),
);
return;
      }
//get the auth service
      final authService = Provider.of<AuthService>(context,listen: false);
      try {
        await authService.SignUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,

        );
      }catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()),),
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
                Text('Let\'s create an account for you',style: TextStyle(
                  fontSize: 16,
                ),),
                SizedBox(height: 25),
                CustomTextField(controller: emailController, hintText: 'Email', obscureText: false),
                SizedBox(height: 10),
                CustomTextField(controller: passwordController, hintText: 'Password', obscureText: true),
           SizedBox(height: 10),
                CustomTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: true),
                SizedBox(height: 25),
                CustomButton(text: 'Sign Up', onTap: signUp),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already a member?'),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Sing In Now',style: TextStyle(
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
