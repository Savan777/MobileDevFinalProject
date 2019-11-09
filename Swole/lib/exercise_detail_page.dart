import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';

class ExerciseDetailPage extends StatefulWidget {

 final DocumentSnapshot exercise;
 ExerciseDetailPage({this.exercise});

 @override
 _ExerciseDetailPage createState() => _ExerciseDetailPage();
  
 }
 class _ExerciseDetailPage extends State<ExerciseDetailPage> {
 @override
 Widget build(BuildContext context) {
   return new Scaffold(
     appBar: new AppBar(
       title: new Text(widget.exercise.data["title"]),
       actions: <Widget>[
         IconButton(
          icon: Icon(Icons.delete),
          onPressed:() {
           var firestore = Firestore.instance;
           firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).delete();
           /*Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => HomeApp()
                    ), 
                  ModalRoute.withName("/Home")
                  );
*/
            Navigator.pop(context);

          },
          
           ),
           IconButton(
          icon: Icon(Icons.add),
          onPressed:() {
           addRepDialog();
          },
          
           )
       ]
     ),
      body: Center(

         child: Padding(padding: EdgeInsets.all(15),
           child: FutureBuilder(
                 future: getExerciseInfo(),
                 builder: (_, snapshot2){
                 if(snapshot2.connectionState == ConnectionState.waiting){
                   return Center(child: Text("Loading..."),
                   );
                 } else {
                   return ListView.builder(
             itemCount: snapshot2.data.length,
             itemBuilder: (_, index) {
               return InkWell( child:
               ListTile(title: Text(snapshot2.data[index].data["weight"] + " lbs x " + snapshot2.data[index].data["reps"], style: TextStyle(fontWeight: FontWeight.normal),),), onLongPress: () => deleteDialog(snapshot2.data[index].data["id"]),
           );},);}})
                )   
       ),
   );
 }

  getExerciseInfo() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).collection("sets").getDocuments();
    return qn.documents;
  }

addRep(weight, reps) async {
  var firestore = Firestore.instance;
  String identifier = DateTime.now().toString();
  firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).collection("sets").document(identifier).setData({"reps": reps, "weight": weight, "id": identifier});
}

  deleteDialog(id) {
    showDialog(
   context: context,
   builder: (BuildContext context) {;
           return AlertDialog(
             content: Form(
               key: null,
               child: 
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: RaisedButton(
                 child: Text("Confirm Delete"),
                 onPressed: () {
                   delete(id);
Navigator.pop(context);

                 },
               ),
          
         ),
       ),
     );
  });
  }

delete(id){
    var firestore = Firestore.instance;

    firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).collection("sets").document(id).delete();
Navigator.pop(context);
}

  addRepDialog() {
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
                     child: TextFormField(decoration: InputDecoration(hintText: "Weight"),controller: myController,),
             ),
             Padding(
                    
                     padding: EdgeInsets.all(8.0),
                     child: TextFormField(decoration: InputDecoration(hintText: "Reps"),controller: myController2,),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: RaisedButton(
                 child: Text("Submit"),
                 onPressed: () {
                   addRep(myController.text, myController2.text);
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
   