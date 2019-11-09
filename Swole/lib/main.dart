import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'package:swole/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swole',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MappingPage(auth: AuthService(),),
    );
  }
}

/*
class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("Swole", textAlign: TextAlign.center)),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () => login(context),
              label: Text('Login with Google'),
            )
          ],
        ),
        ),
    );
  }


  void login(BuildContext context) async {

    await authService.googleSignIn();    
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => HomeApp()), 
      ModalRoute.withName("/Home")
    );
  }
}
*/
