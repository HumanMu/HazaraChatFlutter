
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hazara_room/Services/notification_services.dart';
import 'package:hazara_room/helper/helper_function.dart';
import 'package:hazara_room/screens/login_pages.dart';
import 'package:hazara_room/screens/profile_page.dart';
import 'package:hazara_room/widgets/header.dart';
import 'package:hazara_room/widgets/profile_picture.dart';

import '../Services/Authentication/auth_service.dart';
import '../widgets/text_widgets.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}


class _RegisterPage extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  bool isLoading = false;
  String name = "";
  String email = "";
  String password = "";
  String password2 = "";

  @override
  Widget build (BuildContext context) {
  return Scaffold(
        backgroundColor: Colors.black,
        body: isLoading? const Center(child: CircularProgressIndicator(color: Colors.red),) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          
          // slivers: [
          //   SliverFillRemaining(
          //     hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
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
                        RichText(text: const TextSpan(
                          text: "به هزاره چت خوش آمدی ", 
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20,),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  labelText: "نام کامل ",
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color:  Colors.lightGreen,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.lightGreen),
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                } , 
                                validator: (val) {
                                  if(val!.isNotEmpty){
                                    return null;
                                  } else {
                                    return "Your name is needed";
                                  }
                                },                            
                              ),
                              const SizedBox(height: 8,),
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
                              ),
                              const SizedBox(height: 8,),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  labelText: "رمز ورود",
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color:  Colors.lightGreen,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.lightGreen),
                                onChanged: (val) {
                                  setState(() {
                                      password = val;
                                    }
                                  );
                                } ,                             
                              ),
                              const SizedBox(height: 8,),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  labelText: "تکرار رمز ورود ",
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color:  Colors.lightGreen,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.lightGreen),
                                onChanged: (val) {
                                  setState(() {
                                      password2 = val;
                                    }
                                  );
                                } ,                             
                              ),
                              const SizedBox(height: 8,),
                              _submitButton(),
                          ],)
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        text: "قبلا حساب باز کردی؟ ",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                              text: 'از اینجا وارد شو ',
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (builder) => const LoginPage(),
                                    )); 
                              }
                            ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
        //   ],
        // ),
      );
    }

    // bool _verifyRegistrationInfo () {
    //   final bool isValid = EmailValidator.validate(_email);
    //   if(_password1 != _password2 ) {
    //     showSnackBar(context, 'رمز اول و دوم باید یکی باشد ');
    //     return false;
    //   }
    //   else if(!isValid) {
    //     showSnackBar(context, 'Your email is not valid!');
    //     return false;
    //   }
    //   else {
    //     return true;
    //   }
    // }

    _registerUser() async {  
      if(formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        await authService.registerUserWithEmailAndPassword(name, email, password)
        .then((value) async {
          if(value == true) {
            // Saving data to shared preferences
            await HelperFunction.saveUserLoginStatus(true);
            await HelperFunction.saveUserNameSP(name);
            await HelperFunction.saveUserEmailSP(email);
            
            if(mounted) {
              navigateAndReplaceCurrentScreen(context, const ProfilePage());

              showSnackBar(context, "ثبت نام شما با موفقیت انجام شد ", Colors.green);
              isLoading = false;
            }
            else{
              isLoading = false;
              showSnackBar(context, "اتفاق غیر منتظره رخ داد, لطفا دوباره تلاش کن", Colors.red);
            }
          }
          else {
            showSnackBar(context, "اتفاق غیر منتظره رخ داد, لطفا دوباره تلاش کن", Colors.red);
            isLoading = false;
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
        onPressed: _registerUser, 
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
          child: const Text('ثبت کن ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        ),
    );
    }


}
