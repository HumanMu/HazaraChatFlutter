import 'package:flutter/material.dart';


const textInputDecoration =  InputDecoration(
    
  hintTextDirection: TextDirection.rtl,
  labelStyle: TextStyle(
    color: Colors.limeAccent,
  ),
  filled: true,
  // fillColor: Colors.amber,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: Colors.red,
    ),
  ),

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.limeAccent),
  ),
);

Widget profileButton (context, buttonText, landingPage) {
  return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),),
        backgroundColor: MaterialStateProperty.resolveWith((
            Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.redAccent;
          } else {
            return Colors.lime[800];
          }
        }),),
        
      onPressed: () {
        Navigator.push( context,
          MaterialPageRoute(builder: (context) => landingPage));
      },
      child: Text(buttonText),
      
    );
}


void navigateToAnotherScreen(context, newPage) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => newPage));
}

void navigateAndReplaceCurrentScreen(context, newPage) {
  Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => newPage));
}

Future<void> replaceCurrentWidget(BuildContext context, VoidCallback onSuccess) async {
  await Future.delayed(const Duration(seconds: 2));
  onSuccess.call();
}
  

// https://www.youtube.com/watch?v=2rn3XbBijy4
