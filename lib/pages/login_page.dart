import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/loading.dart';
import 'package:logging/logging.dart';

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

  // Inside the _LoginFormState class
  Future<void> _submit(AuthService auth, Future<AuthResult> Function() action) async {
    if (_formKey.currentState?.validate() ?? false) { // Make sure to check if the form is valid
      _formKey.currentState!.save();
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents dialog from closing on outside tap
        builder: (context) => Loading(),
      );

      AuthResult result = await action(); // Call the passed function, which should return a Future<AuthResult>
      Navigator.pop(context); // Pop the loading dialog

      if (result.success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.errorMessage)));
      }
    }
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

