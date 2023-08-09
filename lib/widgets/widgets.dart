import 'package:flutter/material.dart';
const textInputDecoration = InputDecoration(
     
    labelStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          
      color: Color(0xffee7b64),
      width: 2.0,
    )),
    enabledBorder: OutlineInputBorder(
        
      borderSide: BorderSide(
        color: Color(0xffee7b64),
        
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffee7b64),
        width: 2.0,
      ),
    ));

void nextScreen(dynamic context,dynamic page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(dynamic context, dynamic page) {
  Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (BuildContext context) => page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,
        style:  TextStyle(
          color:Colors.white.withOpacity(.9),
          fontSize: 15.0,
        )),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
          textColor:Colors.white.withOpacity(.9),
    ),
  ));
}
