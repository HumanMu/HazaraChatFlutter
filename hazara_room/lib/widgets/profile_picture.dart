import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AvatarGlow(
      endRadius: 60.0,
      child: Material(
          elevation: 6.0,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent,
            radius: 45,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/icons/chatLogo.png'),
              radius: 40.0,
            ),
          )),
    );
  }
}
