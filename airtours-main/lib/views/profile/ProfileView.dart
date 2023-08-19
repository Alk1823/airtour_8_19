import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/utilities/button.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyButton(
            title: "Update Your Information",
            onPressed: () {
              Navigator.of(context).pushNamed(updateRoute);
            },
            ),
            MyButton(
              title: 'Delete My Account',
              onPressed: () {},)
        ],
      ),
    );
  }
}