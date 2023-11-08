import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/loading.dart';
import 'package:logging/logging.dart';

final _logger = Logger('RegisterPageLogging');

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _secretMessage = ''; // Add a variable for the secret message

  @override
  Widget build(BuildContext context) {
    _logger.info('REGISTERFORM');
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Username'),
            onSaved: (value) => _username = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) => _password = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Secret Message'), // Add a TextFormField for the secret message
            onSaved: (value) => _secretMessage = value!,
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState!.save();
              showDialog(
                context: context,
                builder: (context) => Loading(),
              );
              AuthResult result = await Provider.of<AuthService>(context, listen: false)
                  .register(_username, _password, _secretMessage); // Pass the secret message
              Navigator.pop(context); // Pop the loading dialog
              if (result.success) {
                // Log in the user after successful registration
                AuthResult loginResult = await Provider.of<AuthService>(context, listen: false)
                    .login(_username, _password); 

                if (loginResult.success) {
                  // Navigate to the home screen after successful login
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(loginResult.errorMessage)));
                }
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(result.errorMessage)));
              }
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}

