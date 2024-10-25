// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prayer_app/ui/signup.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage; // Track error messages
  String? _successMessage; // Track success messages
  bool _isLoading = false; // Track loading state
  bool _isButtonVisible = true; // Track button visibility

  Future<void> _login() async {
    setState(() {
      _errorMessage = null; // Clear previous error message
      _successMessage = null; // Clear previous success message
      _isLoading = true; // Start loading
      _isButtonVisible = false; // Hide sign-in button
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.'; // Set error message
        _isLoading = false; // Stop loading
        _isButtonVisible = true; // Show sign-in button
      });

      // Clear the error message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _errorMessage = null; // Clear the error message
        });
      });
      return; // Exit the function if inputs are empty
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Check if the user's email is verified
      if (userCredential.user?.emailVerified ?? false) {
        setState(() {
          _successMessage = 'Successfully logged in'; // Set success message
        });

        // Clear the success message after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _successMessage = null; // Clear the success message
          });
        });

        // Smooth page transition to the Home screen
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Home(user: userCredential.user!), // Ensure user is non-null
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0); // Start from below
              const end = Offset.zero; // End at the current position
              const curve = Curves.easeInOut; // Smooth curve

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Email not verified'),
            content: const Text('Please verify your email before logging in.'),
            actions: [
              TextButton(
                onPressed: () async {
                  await userCredential.user?.sendEmailVerification();
                  Navigator.pop(context);
                },
                child: const Text('Resend Email'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Incorrect email or password.'; // Set error message
      });

      // Clear the error message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _errorMessage = null; // Clear the error message
        });
      });

      print(error); // Log error for debugging
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
        _isButtonVisible = true; // Show sign-in button again
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
                Image.asset(
                  'assets/alburhan.png', // Replace with your image path
                  height: 140, // Adjust the height as needed
                ),
                SizedBox(height: screenSize.height * 0.02), // Spacer for top
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

                // Show Sign In Button or Loader based on visibility
                if (_isButtonVisible)
                  Align(
                    alignment: Alignment.topRight, // Align to the top right
                    child: GestureDetector(
                      onTap: _login,
                      child: Container(
                        width: 200, // Set a specific width or use double.infinity
                        height: 40, // Adjust height as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/signin.png', // Replace with your image path
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Show loader if loading
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  ),

                // Spacer for the "Don't have an account?" text
                SizedBox(
                  height: screenSize.height * 0.12,
                ), // Adjust this value to move the text lower

                // RichText for "Don't have an account?"
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: ' Create',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
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
