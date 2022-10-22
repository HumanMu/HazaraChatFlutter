

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazara_room/Services/Authentication/auth_service.dart';
import 'package:hazara_room/Services/Firestore/firestore_services.dart';
import 'package:hazara_room/Services/notification_services.dart';
import 'package:hazara_room/helper/helper_function.dart';
import 'package:hazara_room/screens/login_pages.dart';
import 'package:hazara_room/screens/profile_page.dart';
import 'package:hazara_room/screens/search_page.dart';
import 'package:hazara_room/widgets/group_tile.dart';
import 'package:hazara_room/widgets/text_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String userEmail = "";
  Stream? groups;
  bool _isLoading = false;
  // String groupName = "";
  final groupName2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

    // String manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }
  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
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

    // getting the groups / snapshots using stream
    await FirestoreService(userId: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            navigateToAnotherScreen(context, const SearchPage());
          }, 
            icon: const Icon(Icons.search),
          ),
        ],
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text("گروه های من ", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          textDirection: TextDirection.rtl,  
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            const Icon(Icons.account_circle,
              size: 150,
              color: Colors.red,
            ),
            const SizedBox(height: 15,),
            Text(userName, textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
            ),
            const SizedBox(height: 15,),
            const Divider( height: 2, ),
            ListTile(
              onTap: () {},
              selectedColor: Colors.red,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5 ),
              leading: const Icon(Icons.group),
              title: const Text( 
                "گروه ",
                style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () {
                navigateToAnotherScreen(context, const ProfilePage());
              },
              selectedColor: Colors.red,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5 ),
              leading: const Icon(Icons.home),
              title: const Text( 
                "صفحه من ",
                style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () {
                authService.logOutUser().whenComplete(() => {
                  navigateAndReplaceCurrentScreen(context, const LoginPage())
                });
              },
              selectedColor: Colors.red,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5 ),
              leading: const Icon(Icons.logout),
              title: const Text( 
                "خروج ",
                style: TextStyle(color: Colors.black),),
            ),
          ],  
        ),
      ),
      body: createGroups(),

      floatingActionButton: FloatingActionButton(
        onPressed: () { popUpDialog(context); },
        elevation: 0,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.red, size: 30,),

        
      ),
    );
  }

  popUpDialog(BuildContext context) {
    // Future.delayed(Duration.zero, (){
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState ) {
              return AlertDialog(
                title: const Text("گروه خودت را بساز ",
                textDirection: TextDirection.rtl, 
                textAlign: TextAlign.right,
            ),
            content: Column( 
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,)) 
                    : TextField(
                        controller: groupName2,
                      // onChanged: (val) {
                      //     groupName = val;
                      //   // setState(() {
                      //   // });
                      // },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder( 
                          borderSide: const BorderSide( color: Colors.red ),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red ),
                          borderRadius: BorderRadius.circular(15),
                        )
                      ),
                    ),

              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(("لغو")),
              ),
            ElevatedButton(
                onPressed: () async{
                  if(groupName2.text != "") {
                    setState(() {
                      _isLoading = true;
                    });

                    FirestoreService(userId: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, 
                      FirebaseAuth.instance.currentUser!.uid, groupName2.text).whenComplete(() {
                        _isLoading = false;

                    });
                    Navigator.of(context).pop();
                    showSnackBar(context, "گروه شما با موفقیت ثبت شد  ", Colors.green);
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
                ),
                child: const Text(("ثبت کن")),
              )]);

        }));
    });
  }
  createGroups() {
    

    return groupList();
  }
  
  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['groups'] != null) { // If snapshot contain data og 'group'
            if(snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1; // For not showing the group id
                  return GroupTile(
                    grouId: getId(snapshot.data['groups'][reverseIndex]), 
                    groupName: getName(snapshot.data['groups'][reverseIndex]), 
                    userName: snapshot.data['fullname']);
                },
              );
            }
            else {
              return noGroupFound();
            }
          }
          else {
            return noGroupFound();
          }
        }
        else {
          return const Center(child: CircularProgressIndicator(
            color: Colors.red,),
            
          );
        }
      },
    );
  }

  noGroupFound()  {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const[
          // GestureDetector(
          //   onTap: popUpDialog(context),
          // ),
          //  Icon(Icons.add_circle, color: Colors.red, size: 75,),
          SizedBox(height: 20),
          Text("شما تا حالا عضو گروهی نیستی ", 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 17
            ), 
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ), 
          Text(" ۱: دکمه پایین سمت راست ' + ' را برای ایجاد گروه فشار بده  \n ۲: علامت جستجو بالا سمت راست را برای جستجوی گروه  که دیگران ایجاد کرده فشار بده ", 
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,            
          ),

        ],
      ),
    );
  }
}