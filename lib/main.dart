import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'loading.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT Auth',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: LoginForm(),
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

  @override
  Widget build(BuildContext context) {
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
              bool success = await Provider.of<AuthService>(context, listen: false)
                  .login(_username, _password);
              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                // Show error message
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Login failed')));
              }
            },
            child: Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('Register'),
                  ),
                  body: RegisterForm(),
                )),
              );
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
              bool success = await Provider.of<AuthService>(context, listen: false)
                  .register(_username, _password);
              Navigator.pop(context); // Pop the loading dialog
              if (success) {
                Navigator.pop(context); // Pop the registration page
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Registration failed')));
              }
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).getHomeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(snapshot.data.toString());
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
