import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hazara_room/Services/Firestore/firestore_services.dart';
import 'package:hazara_room/helper/helper_function.dart';
import 'package:hazara_room/screens/profile_page.dart';
import 'package:hazara_room/screens/register_page.dart';
import 'package:hazara_room/widgets/header.dart';
import 'package:hazara_room/widgets/profile_picture.dart';
import 'package:hazara_room/widgets/text_widgets.dart';

import '../Services/Authentication/auth_service.dart';
import '../Services/notification_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String name = "";
  String email = "";
  String password = "";
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading? const Center(child: CircularProgressIndicator(color: Colors.red)) :CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: ClipPath(
                        clipper: Header(),
                        child: Container(
                          color: Colors.limeAccent,
                          height: 200,
                        ),
                      ),
                    ),
                    ClipPath(
                      clipper: Header(),
                      child: Container(
                        color: Colors.redAccent,
                        height: 185,
                        alignment: Alignment.centerLeft,
                        child: const ProfilePicture(),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                labelText: "ایمیل",
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color:  Colors.lightGreen,
                                ),
                              ),
                              style: const TextStyle(color: Colors.lightGreen),
                              onChanged: (val) {
                                setState(() {
                                    email = val;
                                  }
                                );
                              } ,
                              validator: (val) {
                                
                                bool isValid = EmailValidator.validate(email);
                                return isValid ? null : "یک ایمیل معتبر وارد کن لطفا ";
                              },
                              
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                labelText: "رمز ورود ",
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color:  Colors.lightGreen,
                                ),
                              ),
                              style: const TextStyle(color: Colors.amberAccent),
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              } ,
                              
              
                            ),
                            const SizedBox(height: 15,),
                            _submitButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: "ثبت نام نیستی؟  ",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                            text: 'اینجا ثبت نام کن ',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer() ..onTap = () {
                                navigateAndReplaceCurrentScreen(context, const RegisterPage()); //_navigateAndReplaceCurrentScreen(context, const RegisterPage());
                              }),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  loginUser() async {
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      await authService
        .loginUserWithEmailAndPassword(email, password) 
        .then((value) async {
          if(value == true) {
            // after succes login, we retrieve the user data from firestore and saving them in sharedpreferences
            QuerySnapshot snapshot =  await FirestoreService(userId: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(email);
              await HelperFunction.saveUserLoginStatus(true);
              await HelperFunction.saveUserNameSP( snapshot.docs[0]['fullname']);
              await HelperFunction.saveUserEmailSP(email);

              if(mounted) {
                navigateAndReplaceCurrentScreen(context, const ProfilePage());

              showSnackBar(context, "ثبت نام شما با موفقیت انجام شد ", Colors.green);
            }
            else{
              showSnackBar(context, "اتفاق غیر منتظره رخ داد, لطفا دوباره تلاش کن", Colors.red);
            }
          }
          else {
              showSnackBar(context, "اتفاق غیر منتظره رخ داد, لطفا دوباره تلاش کن", Colors.red);
            setState(() {
              _isLoading = false;
            });
          }
        });
    }
  }

  Widget _submitButton() {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.lime[800],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
        ),
      ),
      child: ElevatedButton(
        onPressed: loginUser, 
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
          backgroundColor: MaterialStateProperty.resolveWith((
            Set<MaterialState>states) {
              if(states.contains(MaterialState.pressed)) {
                return Colors.redAccent;
              }else {
                return Colors.lime[800];
              }
            }
          )),
          child: const Text('ورود ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        ),
    );
  }

//  Widget _entryField(
//       String title,
//       TextEditingController controller,
//     ) {
//       return TextFormField(
//         controller: controller,
        
//         decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             borderSide: const BorderSide(
//               width: 2, 
//               color: Colors.lightGreen,
//             ),
//           ),
//           labelText: title,
//           filled: true,
//           fillColor: Colors.grey[800],
//           labelStyle: const TextStyle(
//             color: Colors.lightGreen,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: const BorderSide(
//               width: 1,
//               color: Colors.red,
//             )
//           ),
//         ),
//       );
//     }

}

// To solve login see minut 49


