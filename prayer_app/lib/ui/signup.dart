// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prayer_app/ui/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage; // Track error messages
  String? _successMessage; // Track success messages

  bool _isSigningUp = false; // State to track if the sign-up process is ongoing

  Future<void> _signUp() async {
    setState(() {
      _isSigningUp = true; // Disable button when signing up starts
      _errorMessage = null;
      _successMessage = null;
    });

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
        _isSigningUp = false; // Re-enable button if inputs are empty
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _errorMessage = null;
        });
      });
      return;
    }

    try {
      // Firebase Authentication to sign up the user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save the user's display name
      await userCredential.user?.updateDisplayName(_nameController.text);

      // Send email verification link
      await userCredential.user?.sendEmailVerification();

      // Show success message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'A verification link has been sent to your email. Please verify before logging in.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      ));

      // Navigate to Login screen with a slide transition
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // Slide from below
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration:
              const Duration(milliseconds: 300), // Duration of the transition
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          setState(() {
            _errorMessage =
                'The email is already in use. Please use a different email.';
          });
        } else {
          setState(() {
            _errorMessage = 'Error during signup. Please try again.';
          });
        }
      }

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _errorMessage = null;
        });
      });
    } finally {
      setState(() {
        _isSigningUp = false; // Re-enable button when process is done
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Image
                Image.asset(
                  'assets/alburhan.png', // Replace with your image path
                  height: 140, // Adjust the height as needed
                ),

                SizedBox(height: screenSize.height * 0.02), // Spacer
                const Text(
                  'السَّلاَمُ عَلَيْكُمْ ',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(height: screenSize.height * 0.03), // Spacer

                // Error message display
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                // Success message display
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green),
                    ),
                  ),

                // Name TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.all(15),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05), // Spacer

                // Email TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.all(15),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05), // Spacer

                // Password TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.all(15),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05), // Spacer

                // Sign Up Button
                if (!_isSigningUp) // Show button only when not signing up
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _signUp, // Call _signUp when button is tapped
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                            image: AssetImage('assets/signup.png'),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Loading Indicator
                if (_isSigningUp) // Show loading indicator when signing up
                  const CircularProgressIndicator(),
                SizedBox(height: screenSize.height * 0.03), // Spacer

                // Already have an account? Login
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: Color(0xFF35CBE0),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                      ),
                    ],
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
