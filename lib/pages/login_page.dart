import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/loading.dart';
import '../state/state_service.dart';
import 'package:logging/logging.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



final _logger = Logger('LoginPageLogging');

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("background.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 100, // Adjust the position as needed to align with the cloud
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Memory Center',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'YourFontFamily', // Replace with your font family
                  fontSize: 48,
                  color: Colors.yellow,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: LoginForm(),
          ),
        ],
      ),
    );
  }
}



class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<void> _submit(AuthService auth, Future<AuthResult> Function() action) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Loading(),
      );

      AuthResult result = await action();
      Navigator.pop(context); // Pop the loading dialog

      if (result.success) {
        // Retrieve and save the user profile information after successful login
        try {
          User currentUser = await UserService().getUser(null); // Pass null to indicate current user
          await saveUserToSharedPreferences(currentUser); // Save to SharedPreferences
          Navigator.pushReplacementNamed(context, '/home');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load user profile: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage)),
        );
      }
    }
  }

  // Helper method to save the user to SharedPreferences
  Future<void> saveUserToSharedPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }


  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    _logger.info('LoginForm');

    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.5, // Maximum width is 50% of screen width
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Username', filled: true, fillColor: Colors.white.withOpacity(0.8)),
                onSaved: (value) => _username = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white.withOpacity(0.8)),
                obscureText: true,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submit(auth, () => auth.login(_username, _password)),
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Need an account? Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

