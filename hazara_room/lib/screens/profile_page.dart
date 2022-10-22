import 'package:flutter/material.dart';
import 'package:hazara_room/Services/Authentication/auth_service.dart';
import 'package:hazara_room/helper/helper_function.dart';
import 'package:hazara_room/screens/home_page.dart';
import 'package:hazara_room/widgets/profile_picture.dart';
import 'package:hazara_room/widgets/text_widgets.dart';
import '../widgets/header.dart';

class ProfilePage extends StatefulWidget {
  // UserModel  userModel;
  const ProfilePage({ super.key, });

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  AuthService authService = AuthService();
  bool editing = true;
  bool isSignedIn = false;

  String userName = "";
  String userEmail = "";

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _creditController = TextEditingController();
  final _aboutMeController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    getUserLoggedInState();
  }

  getUserLoggedInState() async {
    await HelperFunction.getUserLoggedInState().then((val) {
      if(val != null) {
        isSignedIn = val;
      }
    });
  }

  getUserData() async {
  await HelperFunction.getUserName().then((val) {
    setState((){
      userName = val!;
    });
  });
  await HelperFunction.getUserEmail().then((val) {
    setState((){
      userEmail = val!;
    });
  });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _profileInformation(context),
    );
  }


  Widget _profileInformation(context) {



    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('در باره من ', style: TextStyle(color: Colors.white, fontSize: 45), ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Text(userName , style: const TextStyle(color: Colors.white, ), textAlign: TextAlign.center,) ),
                        const SizedBox(width: 55, child: Text(' : نام  ', style: TextStyle(color: Colors.white,), )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: _entryField(_emailController, editing )),
                        const SizedBox(width: 55, child: Text(': ایمیل  ', style: TextStyle(color: Colors.white,), )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: _entryField(_creditController, editing )),
                        const SizedBox(width: 55, child: Text(': امتیاز ', style: TextStyle(color: Colors.white,), )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: _entryField(_aboutMeController, editing )),
                        const SizedBox(width: 55, child: Text(' : درباره من', style: TextStyle(color: Colors.white,), )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _homePage(),
                        _goToChatRoom(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _entryField( TextEditingController textController, bool interaction ) {
    return  TextField(
      enabled: interaction,
      controller: textController,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),        
        labelStyle: TextStyle(
            color: Colors.lightGreen,
          ),
      ),
      style: const TextStyle(color: Colors.white),      
    );
  }

  Widget _homePage() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),),
        backgroundColor: MaterialStateProperty.resolveWith((
            Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.redAccent;
          } else {
            return Colors.lime[800];
          }
        }),),
      onPressed: () {
        navigateToAnotherScreen(context, const HomePage());
      },
      child: const Text('خانه '),
      
    );
  }

  Widget _goToChatRoom() {
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
          MaterialPageRoute(builder: (context) => const HomePage()));
      },
      child: const Text(' اتاق بحث '),
      
    );
  }


}
