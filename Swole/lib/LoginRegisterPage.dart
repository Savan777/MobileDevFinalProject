import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:swole/homepage.dart';
import 'Authentication.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

enum FormType { login, register }

class _LoginRegisterState extends State<LoginRegisterPage> {
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  //methods
  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          print("login userId = " + userId);
        } else {
          String userId = await widget.auth.SignUp(_email, _password);
          print("register userId = " + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        print("Error = " + e.toString());
      }
    }
  }

  void singInGoogle() {
    authService.googleSignIn();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomeApp(
                  auth: Auth(),
                )),
        ModalRoute.withName("/Home"));
  }

  //transition to register page
  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

//transition to login page
  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //design
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title:
            new Center(child: new Text("Swole", textAlign: TextAlign.center)),
      ),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }

//creats a vertical view
  List<Widget> createInputs() {
    return [
      logo(),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email', icon: new Icon(Icons.mail, color: Colors.grey)),
        validator: (value) {
          return value.isEmpty ? 'Email is Required.' : null;
        },
        onSaved: (value) {
          return _email = value.trim();
        },
      ),
      new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(Icons.lock, color: Colors.grey)),
        obscureText: true,
        validator: (passvalue) {
          return passvalue.isEmpty ? 'Password is Required' : null;
        },
        onSaved: (passvalue) {
          return _password = passvalue.trim();
        },
      ),
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.asset('assets/flutter-icon.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.green,
          onPressed: validateAndSubmit,
        ),
        new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: new Text("Sign in with Google",
              style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.blueAccent,
          onPressed: singInGoogle,
        ),
        new FlatButton(
          child: new Text("Create New Account",
              style: new TextStyle(fontSize: 18.0)),
          textColor: Colors.deepOrange,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child:
              new Text("Create Account", style: new TextStyle(fontSize: 18.0)),
          textColor: Colors.white,
          color: Colors.green,
          onPressed: validateAndSubmit,
        ),
        new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: new Text("Already have Account? Login",
              style: new TextStyle(fontSize: 18.0)),
          textColor: Colors.white,
          color: Colors.green,
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
