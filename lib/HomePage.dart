import 'package:firebaseproject2/AddProject.dart';
import 'package:firebaseproject2/ViewProduct.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> AddProject()));
              },
              title: Text("ADD PRODUCT"),
            ),
            Divider(color: Colors.black,),
            SizedBox(height: 15.0,),
            ListTile(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> ViewProduct()));
              },
              title: Text("VIEW PRODUCT"),
            ),
            Divider(color: Colors.black,),
          ],
        ),
      ),
    );
  }
}
