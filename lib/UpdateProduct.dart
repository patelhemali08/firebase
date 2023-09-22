import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseproject2/ViewProduct.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateProduct extends StatefulWidget {

  var id;
  UpdateProduct({this.id});


  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {

  ImagePicker picker = ImagePicker();
  File? imagefile = null;
  var imageurl = "";
  var imagename = "";

  TextEditingController _name = TextEditingController();
  TextEditingController _discription= TextEditingController();
  TextEditingController _rpraice = TextEditingController();
  TextEditingController _spraice = TextEditingController();

  getdata(){
    FirebaseFirestore.instance.collection("Product").doc(widget.id).get().then((document){
      setState(() {
        _name.text = document["name"].toString();
        _discription.text = document["desc"].toString();
        _rpraice.text = document["rprice"].toString();
        _spraice.text = document["sprice"].toString();
        imageurl = document["imageurl"];
        imagename = document["imagename"];
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UpdateProduct"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (imagefile!=null)?Image.file(imagefile!,height: 150,):(imageurl!="")?Image.network(imageurl,height: 200,):Image.asset("image/dog.jpg",height: 150,),

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

                  if(imagefile!=null)
                    {
                      var uuid = Uuid();
                      var filename = uuid.v1().toString()+".jpg";
                      print("file name");
                      FirebaseStorage.instance.ref(imagename).delete().then((value){
                        FirebaseStorage.instance.ref(filename).putFile(imagefile!).whenComplete((){}).then((filedata){
                          filedata.ref.getDownloadURL().then((fileurl){
                            FirebaseFirestore.instance.collection("Product").doc(widget.id).update({
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

                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>ViewProduct()));
                            });
                          });
                        });
                      });

                    }
                  else
                    {
                      FirebaseFirestore.instance.collection("Product").doc(widget.id).update({
                        "name":name,
                        "desc":description,
                        "rprice":rpraice,
                        "sprice":spraise,
                      }).then((value){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>ViewProduct()));
                      });
                    }
                  print(name);
                  print(description);
                  print(rpraice);
                  print(spraise);
                  print("value inserted");
                },
                child: Text("SUBMIT")
            ),

          ],
        ),
      ),
    );
  }
}
