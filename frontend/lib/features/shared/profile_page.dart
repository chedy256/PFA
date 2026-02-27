import 'package:flutter/material.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/user.dart';
import 'package:pfa/features/shared/profile_widgets.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return user is Student ?  Scaffold(appBar: AppBar(),body: mainScafford()) : mainScafford(); 
  }


  SafeArea mainScafford(){
    return SafeArea(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24)+EdgeInsets.only(top: 48),
          child: Center(
            child: Column(
              spacing: 24,
              children: [
                infosSection(user),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 12,
                      children: [
                        const Text('Page de profil en construction...'),
                        LogoutButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}


