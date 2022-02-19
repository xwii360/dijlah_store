import 'package:flutter/material.dart';
TextStyle navBarTitleStyle=TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey[600],fontFamily:"sans");
TextStyle navBarHeaderStyle=TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white,fontFamily:"sans");
TextStyle navBarHeaderStyle2=TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.grey[800],fontFamily:"sans");
TextStyle loginTitleStyle1=TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black,fontFamily:"sans");
TextStyle loginTitleStyle2=TextStyle(fontSize: 15,color: Colors.grey,fontFamily:"sans");
TextStyle loginTitleStyle3=TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.green[200],fontFamily:"sans");
TextStyle labelTextInput=TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey[700],fontFamily:"sans");
TextStyle hintTextInput=TextStyle(fontSize: 15,color: Colors.grey[600],fontFamily:"sans");
TextStyle buttonTextLogin= TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black,fontFamily:"sans");
TextStyle button2TextLogin= TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color:Colors.black,fontFamily:"sans");
RoundedRectangleBorder shape1= RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.grey[300]));
Color gradientColor1=Color(0xff86f7b6);
Color gradientColor2= Color(0xff8fd3f1);
Color color1=  Color(0xff80bec6);

inputDecoration(hintText){
  return  InputDecoration(
    hintText:hintText,
    hintStyle:hintTextInput,
    contentPadding: EdgeInsets.only(right: 10,left: 10),
    border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: new BorderSide(color: Colors.teal[300])),
    focusedBorder: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
        borderSide: new BorderSide(color: Colors.teal[300])),
  );
}