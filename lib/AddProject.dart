import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseproject2/ViewProduct.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProject extends StatefulWidget {


  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {

  ImagePicker picker = ImagePicker();
  File? imagefile = null;

  TextEditingController _name = TextEditingController();
  TextEditingController _discription= TextEditingController();
  TextEditingController _rpraice = TextEditingController();
  TextEditingController _spraice = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AddProject"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (imagefile!=null)?Image.file(imagefile!,height: 150,):Image.asset("image/dog.jpg",height: 150,),

            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 50,),
                ElevatedButton(
                    onPressed: ()async{
                      XFile? photo = await picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        imagefile = File(photo!.path);
                        print("imagefile");
                      });
                    },
                    child:Text("CAMERA")
                ),
                SizedBox(width: 50,),
                ElevatedButton(
                    onPressed: ()async{
                      XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imagefile = File(image!.path);
                      });
                    },
                    child:Text("GALLARY")
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text("Name"),
            TextField(
              controller: _name,
              keyboardType: TextInputType.text,
            ),
            Text("Description"),
            TextField(
              controller: _discription,
              keyboardType: TextInputType.text,
            ),
            Text("R praice"),
            TextField(
              controller: _rpraice,
              keyboardType: TextInputType.text,
            ),
            Text("S praice"),
            TextField(
              controller: _spraice,
              keyboardType: TextInputType.text,
            ),
            ElevatedButton(
                onPressed:(){

                  var name = _name.text.toString();
                  var description = _discription.text.toString();
                  var rpraice = _rpraice.text.toString();
                  var spraise = _spraice.text.toString();

                  var uuid = Uuid();
                  var filename = uuid.v1().toString()+".jpg";
                  print("file name");

                  FirebaseStorage.instance.ref(filename).putFile(imagefile!).whenComplete((){}).then((filedata){
                   filedata.ref.getDownloadURL().then((fileurl){
                     FirebaseFirestore.instance.collection("Product").add({
                       "name":name,
                       "desc":description,
                       "rprice":rpraice,
                       "sprice":spraise,
                       "imagename":filename,
                       "imageurl":fileurl

                     }).then((value){
                       print(name);
                       print(description);
                       print(rpraice);
                       print(spraise);
                       print("value inserted");
                     });

                     Navigator.of(context).push(
                       MaterialPageRoute(builder: (context)=>ViewProduct()));
                   });
                  });
                },
                child: Text("SUBMIT")
            ),
            
          ],
        ),
      ),
    );
  }
}
