import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/screens/auth/auth_validators.dart';
import 'package:taskify/utils/colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  final _authValidators = AuthValidators();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Password reset email sent. Check your inbox.")),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = _handleAuthError(e.code);
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'An unexpected error occurred.';
          });
        }
        print('Error sending password reset email: $e');
      }
    }
  }

  String? _handleAuthError(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found with that email.';
      default:
        return 'An error occurred. Please try again later.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: _authValidators.validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CustomColors.kblack,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Error message display
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              // Reset password button
              ElevatedButton(          
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                     await _resetPassword();
                       if (mounted) {
                    Navigator.pop(context);
                  }
                  }         
                
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.korangeDark,
                ),
                child: const Text(
                  "Send password reset link",
                  style: TextStyle(color: CustomColors.kwhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
