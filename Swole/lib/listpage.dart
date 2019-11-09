import 'package:swole/main.dart';
import 'package:swole/settings.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Constants.dart';
import 'package:intl/intl.dart';
import 'detailpage.dart';
import 'homepage.dart';
import 'fooddetailpage.dart';

class ListPage extends StatefulWidget {
 @override
 _ListPageState createState() => _ListPageState();
 }
 class _ListPageState  extends State<ListPage> with SingleTickerProviderStateMixin{
 TabController _tabController;

 Future getWorkouts() async {
   var firestore = Firestore.instance;

   QuerySnapshot qn = await firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("workouts").getDocuments();

   return qn.documents;
 }

 void addWorkouts(String name) async {
   print("Request to add: " + name);
   var firestore = Firestore.instance;

   firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("workouts").document(name).setData({"title": name});
 }

 void addFoodEntry(String foodName) async {
   print("Request to add: " + foodName);
   var firestore = Firestore.instance;

   firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("food").document(foodName).setData({"date": foodName});
 }


 Future getFood() async {
   var firestore = Firestore.instance;

   QuerySnapshot qn = await firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("food").getDocuments();

   return qn.documents;
 }

 navigateToDetail(DocumentSnapshot workout){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(workout: workout,)));
 }

 navigateToFoodDetail(DocumentSnapshot food){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodDetailPage(food: food,)));
 }

 void choice(String choice){
   if(choice == Constants.logout){
     print("Logging out");
     authService.signOut();
     Navigator.pushAndRemoveUntil(
     context,
     MaterialPageRoute(
       builder: (context) => MyApp()
     ),
    ModalRoute.withName("/Home")
   );
    
   } else if (choice == Constants.settings){
     print(authService.currUser().toString());
     Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => SettingApp())
     );
    
   }

   else if (choice == Constants.workout){
     showDialog(
   context: context,
   builder: (BuildContext context) {
     final myController = TextEditingController();
           return AlertDialog(
             content: Form(
               key: null,
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   Padding(
                     padding: EdgeInsets.all(8.0),
                     child: TextFormField(controller: myController,),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: RaisedButton(
                 child: Text("Submit"),
                 onPressed: () {
                   addWorkouts(myController.text);
                   Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => HomeApp()
                    ), 
                  ModalRoute.withName("/Home")
                  );
                 },
               ),
             )
           ],
         ),
       ),
     );
   });
   }

   else if (choice == Constants.food){
     addFoodEntry(DateFormat.yMMMMd().format(DateTime.now()));
     Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => HomeApp()
                    ), 
                  ModalRoute.withName("/Home")
                  );
   }
  
 }

 void initState(){
   _tabController = new TabController(length: 3, vsync: this);
 }

  void dispose(){
   _tabController.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return DefaultTabController(
     length: 2,
     child: Scaffold(
     appBar: AppBar(
       title: Text(" Swole"),
       actions: <Widget>[
         PopupMenuButton<String>(
           onSelected: choice,
           itemBuilder: (BuildContext context){
             return Constants.choices.map((String choice){
               return PopupMenuItem<String>(
                 value: choice,
                 child: Text(choice));
             }).toList();
           },
           )
       ],
       bottom: TabBar(
         controller: _tabController,
         tabs: <Widget>[
           Tab(
             text: "Food"
            
           ),
           Tab(
             text: "Workouts"
           ),
           Tab(
             text: "Analytics"
           ),
         ],
       ), 
     ),
     body: new TabBarView(
       controller: _tabController,
       children: <Widget>[
         Container(
               child: FutureBuilder(
                 future: getFood(),
                 builder: (_, snapshot){
                 if(snapshot.connectionState == ConnectionState.waiting){
                   return Center(child: Text("Loading..."),
                   );
                 } else {
                   return ListView.builder(
                           itemCount: snapshot.data.length,
                           itemBuilder: (_, index){
                             return
                               InkWell(

                               child: Card(
                                 margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                 child:Container(
                                 padding: EdgeInsets.all(0),
                                 height: 60,
                                 child: Center(child:Text(snapshot.data[index].data["date"], style: new TextStyle(fontSize: 16),)
                                 ),
                                
                               ),
                               ),
                               onTap: () => navigateToFoodDetail(snapshot.data[index]),
                            
                            
                             );
                            
                           }
                     );
                 }
               },
              
               ),
              
              
             ),
         
         Container(
               child: FutureBuilder(
                 future: getWorkouts(),
                 builder: (_, snapshot){
                 if(snapshot.connectionState == ConnectionState.waiting){
                   return Center(child: Text("Loading..."),
                   );
                 } else {
                   return ListView.builder(
                           itemCount: snapshot.data.length,
                           itemBuilder: (_, index){
                             return
                               InkWell(

                               child: Card(
                                 margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                 child:Container(
                                 padding: EdgeInsets.all(0),
                                 height: 60,
                                 child: Center(child:Text(snapshot.data[index].data["title"], style: new TextStyle(fontSize: 16),)
                                 ),
                                
                               ),),
                               onTap: () => navigateToDetail(snapshot.data[index]),
                            
                            
                             );
                            
                           }
                     );
                 }
               },
               ),
             ),
             Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize,
              ),
              alignment: Alignment.center,
              child: Text("Coming soon"),
              
            ),


       ],),
     )
    
  
   );
 }

}

