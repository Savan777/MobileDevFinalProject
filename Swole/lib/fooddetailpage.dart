import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';

class FoodDetailPage extends StatefulWidget {

 final DocumentSnapshot food;
 FoodDetailPage({this.food});

 @override
 _FoodDetailPageState createState() => _FoodDetailPageState();
  
 }
 class _FoodDetailPageState extends State<FoodDetailPage> {
 @override
 Widget build(BuildContext context) {
   return new Scaffold(
     appBar: new AppBar(
       title: new Text(widget.food.data["date"]),
       actions: <Widget>[
         IconButton(
          icon: Icon(Icons.delete),
          onPressed:() {
           var firestore = Firestore.instance;
           firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("food").document(widget.food.documentID).delete();
                  Navigator.pop(context);
          },
          
           ),
           IconButton(
          icon: Icon(Icons.add),
          onPressed:() {
           addFoodItemDialog();
          },
          
           )
       ]
     ),
      body: Center(

         child: Padding(padding: EdgeInsets.all(15),
           child: FutureBuilder(
                 future: getFoodEntry(),
                 builder: (_, snapshot2){
                 if(snapshot2.connectionState == ConnectionState.waiting){
                   return Center(child: Text("Loading..."),
                   );
                 } else {
                   return ListView.builder(
             itemCount: snapshot2.data.length,
             itemBuilder: (_, index) {
               return 
               Column( children: <Widget>[
                 //ListTile(title: Text(snapshot2.data[index].data["name"], subtitle: Text(snapshot2.data[index].data["name"]), style: TextStyle(fontWeight: FontWeight.normal),), ), new Divider()
               Card(
                  child: ListTile(
                    title: Text(snapshot2.data[index].data["name"]),
                    subtitle: Text(snapshot2.data[index].data["calories"] + " calories"),
                  ),
                )
               ]);
             },
             );
             }})
                )   
       ),
   );
 }

  getFoodEntry() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("food").document(widget.food.data["date"]).collection("data").getDocuments();
    return qn.documents;
  }


  addFoodItem(String text, String text2){
  print("Request to add: " + text);
    var firestore = Firestore.instance;

    firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("food").document(widget.food.data["date"]).collection("data")..document(text).setData({"name": text, "calories": text2});
  }

  addFoodItemDialog() {
    showDialog(
   context: context,
   builder: (BuildContext context) {
     final myController = TextEditingController();
     final myController2 = TextEditingController();
           return AlertDialog(
             content: Form(
               key: null,
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   Padding(
                     padding: EdgeInsets.all(8.0),
                     child: TextFormField(decoration: InputDecoration(hintText: "Name"), controller: myController,),
             ),
             Padding(
                     padding: EdgeInsets.all(8.0),
                     child: TextFormField(decoration: InputDecoration(hintText: "Calories"),controller: myController2,),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: RaisedButton(
                 child: Text("Submit"),
                 onPressed: () {
                   addFoodItem(myController.text, myController2.text);
                   Navigator.pop(context);
                 },
               ),
             )
           ],
         ),
       ),
     );
  });
  }
 }
   
