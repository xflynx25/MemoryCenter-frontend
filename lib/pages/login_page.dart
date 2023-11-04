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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(),
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

  @override
  Widget build(BuildContext context) {
    _logger.info('LOGINFORM');
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
          ElevatedButton(
            onPressed: () async {
            _formKey.currentState!.save();
            showDialog(
              context: context,
              builder: (context) => Loading(),
            );
            AuthResult result = await Provider.of<AuthService>(context, listen: false)
                .login(_username, _password); // or .register for the RegisterForm
            Navigator.pop(context); // Pop the loading dialog
            if (result.success) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result.errorMessage)));
            }
          },
            child: Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

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
          ElevatedButton(
            onPressed: () async {
            _formKey.currentState!.save();
            showDialog(
              context: context,
              builder: (context) => Loading(),
            );
            AuthResult result = await Provider.of<AuthService>(context, listen: false)
                .login(_username, _password); // or .register for the RegisterForm
            Navigator.pop(context); // Pop the loading dialog
            if (result.success) {
              Navigator.pushReplacementNamed(context, '/home');
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
