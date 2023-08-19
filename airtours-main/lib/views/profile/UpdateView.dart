import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_service.dart';


class UpdateView extends StatefulWidget {
  const UpdateView({super.key});

  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  late final TextEditingController _email;
  final FirebaseCloudStorage c = FirebaseCloudStorage();


  @override
  void initState() {
    _email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
          ),
          TextButton(
            onPressed: () {
              //DB
              final String currentUser = AuthService.firebase().currentUser!.id;
              c.updateUser(
                ownerUserId: currentUser,
                email: _email.text,
                phoneNum: "0580647715"
                //DB end
              );
            },
             child: const Text('update!')
             )
        ],
      ),
    );
  }
}

