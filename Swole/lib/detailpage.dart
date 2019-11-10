import 'package:swole/exercise_detail_page.dart';

import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';

class DetailPage extends StatefulWidget {

 final DocumentSnapshot workout;
 DetailPage({this.workout});

 @override
 _DetailPageState createState() => _DetailPageState();
 }
 
 class _DetailPageState extends State<DetailPage> {
 @override
 Widget build(BuildContext context) {
   return new Scaffold(
     appBar: new AppBar(
       title: new Center(child: new Text(widget.workout.data["title"], textAlign: TextAlign.center)),
       actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed:() {
           var firestore = Firestore.instance;
           firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("workouts").document(widget.workout.documentID).delete();
           Navigator.pop(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed:() {
           addExerciseDialog();
          },
        )
       ]
     ),
     body: Center(

         child: Padding(padding: EdgeInsets.all(15),
           child: FutureBuilder(
                 future: getExercise(),
                 builder: (_, snapshot){
                 if(snapshot.connectionState == ConnectionState.waiting){
                   return Center(child: Text("Loading..."),
                   );
                 } else {
                   return ListView.builder(
             itemCount: snapshot.data.length,
             itemBuilder: (_, index) {
               return
                               InkWell(

                               child: Card(
                                 margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                 child:Container(
                                 padding: EdgeInsets.all(0),
                                 height: 60,
                                 child: Center(child:Text(snapshot.data[index].data["title"], style: new TextStyle(fontSize: 16),)
                                 ),
                                
                               ),
                               ),
                               onTap: () => navigateToExerciseDetail(snapshot.data[index]),
                               onLongPress: () => print("LONG PRESS"),
                            
                            
                             );
             },);}})
                )   
       ),
   );
 }

  navigateToExerciseDetail(DocumentSnapshot exercise){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetailPage(exercise: exercise,)));
 }

  getExercise() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("workouts").document(widget.workout.data["title"]).collection("data").getDocuments();
    return qn.documents;
  }

  
  addExercise(String text){
  print("Request to add: " + text);
    var firestore = Firestore.instance;

    firestore.collection("user_data").document(authService.getCurrentUser().toString()).collection("workouts").document(widget.workout.data["title"]).collection("data").document(text).setData({"title": text, "workout": widget.workout.data["title"]});
  }

  addExerciseDialog() {
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
                   addExercise(myController.text);
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
