import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseproject2/UpdateProduct.dart';
import 'package:flutter/material.dart';

class ViewProduct extends StatefulWidget {


  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ViewProduct"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Product").snapshots(),
        builder: (context,snapshot)
        {
          if(snapshot.hasData)
            {
              if(snapshot.data!.size<=0)
                {
                  return Center(child: Text("No Data"),);
                }
              else
                {
                  return ListView(
                    children: snapshot.data!.docs.map((document){
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                        ),

                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Image.network(document["imageurl"],height: 100,),
                            SizedBox(height: 10.0,),
                            Text("name : "+document["name"].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                            Divider(color: Colors.black,),

                            Text("desc : "+document["desc"].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                            Divider(color: Colors.black,),

                            Text("rpraice : "+document["rprice"].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                            Divider(color: Colors.black,),

                            Text("spraice : "+document["sprice"].toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                            Divider(color: Colors.black,),

                           Row(
                             children: [
                               SizedBox(width: 50,),
                               ElevatedButton(
                                   style: ElevatedButton.styleFrom(
                                     primary: Colors.red,),
                                   onPressed: (){
                                     AlertDialog alert = AlertDialog(
                                       title: Text("NAME"),
                                       content: Text("ARE YOU SURE"),
                                       actions: [
                                         ElevatedButton(
                                             onPressed: (){

                                               var id = document.id.toString();
                                               print(id);

                                               // FirebaseStorage.instance.ref(document["imagename"]).delete().then((value) {
                                               // });
                                               FirebaseStorage.instance.ref(document["imagename"]).delete().then((value) {
                                                 FirebaseFirestore.instance.collection("Product").doc(id).delete().then((value){
                                                   print("record delete");

                                                   Navigator.of(context).push(
                                                       MaterialPageRoute(builder: (context)=>ViewProduct()));
                                                 });
                                               });

                                             },
                                             child: Text("YES")
                                         ),
                                         ElevatedButton(

                                             onPressed: (){
                                               Navigator.of(context).pop();
                                             },
                                             child: Text("NO")
                                         ),
                                       ],
                                     );
                                     showDialog(context: context, builder: (context){
                                       return alert ;
                                     });
                                   },
                                   child: Text("DELETE")
                               ),
                               SizedBox(width: 50,),
                               ElevatedButton(
                                   style: ElevatedButton.styleFrom(
                                     primary: Colors.red,),
                                   onPressed: (){
                                     var id = document.id.toString();
                                     print(id);

                                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateProduct(id: id,)));
                                   },
                                   child: Text("UPDATE")
                               ),
                             ],
                           )
                          ],
                        )
                        
                      );

                    }).toList(),
                  );
                }
            }
          else
            {
              return Center(child: CircularProgressIndicator(),);
            }
        },
      ),
    );
  }
}
