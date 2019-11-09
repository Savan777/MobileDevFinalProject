import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'Mapping.dart';
import 'Authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swole',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MappingPage(auth: Auth(),),
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
