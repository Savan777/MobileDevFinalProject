import 'package:flutter/material.dart';
import 'auth.dart';

class SettingApp extends StatelessWidget {

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Swole',
     theme: ThemeData(
       primarySwatch: Colors.green,
     ),
     home: new SettingScreen(),
   );
 }
}

class SettingScreen extends StatelessWidget {

 @override
 Widget build(BuildContext context) {
   return new Scaffold(
     appBar: new AppBar(
       title: new Center(child: new Text("Settings", textAlign: TextAlign.center)),
     ),
     body: Center(

         child: Padding(padding: EdgeInsets.all(15),
           child: 
         Column(
           children: <Widget>[
            ListTile(title: Text("User Information", style: TextStyle(fontWeight: FontWeight.bold),)),
            ListTile(title: Text(authService.currUser().displayName.toString())), 
            ListTile(title: Text(authService.currUser().email.toString())),
            new Divider(),
            ListTile(title: Text("Application", style: TextStyle(fontWeight: FontWeight.bold),)),
            ListTile(title: Text("Build 1106"))],
         )
                ,)   
                 
           
       ),
   );
 }
}



