import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hazara_room/helper/helper_function.dart';
import 'package:hazara_room/screens/login_pages.dart';
import 'package:hazara_room/screens/profile_page.dart';
import 'shared/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb) { // this one is only for web if it get added in the future
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Constant.apiKey, 
        appId: Constant.apiKey, 
        messagingSenderId: Constant.messagingSenderId, 
        projectId: Constant.projectId,
      ),
    );
  }
  else {
    await Firebase.initializeApp(); // If user is from a phone
  }

  runApp(  const HazaraChat());

}

class HazaraChat extends StatefulWidget {
  const HazaraChat({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<HazaraChat> createState() => _HazaraChat();

}

class _HazaraChat extends State<HazaraChat> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInState();
  }

  getUserLoggedInState() async {
    await HelperFunction.getUserLoggedInState().then((value) {
      if(value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp( 
        debugShowCheckedModeBanner: false,
      home: _isSignedIn? const ProfilePage() : const LoginPage(),
    );         
  }
}


// https://www.youtube.com/watch?v=Qwk5oIAkgnY -  3:38 timer efter