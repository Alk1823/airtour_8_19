

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/auth_service.dart';
import '../../utilities/show_error.dart';




class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phoneNum;
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _phoneNum = TextEditingController();
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
          TextField(
            controller: _password,
          ),
          TextField(
            controller: _phoneNum,
          ),
          TextButton(
            onPressed: () async {
               try {
                  await AuthService.firebase().createUser(
                    email: _email.text, 
                    password: _password.text
                    );
                  //DB
                c.createNewAdmin(
                    email: _email.text,
                    phoneNum: _phoneNum.text
                  );
                
                  //DB end
                }
                on WeakPasswordAuthException {
                  await showErrorDialog(context, 'Weak Password');
                }
                on EmailAlreadyInUseAuthException {
                 
                  await showErrorDialog(context, 'Email already in use ');
                }
                on InvalidEmailAuthException {
                  await showErrorDialog(context, 'this is an invalid email');
                }
                on GenericAuthException {
                  await showErrorDialog(context, 'failed to add');
                }
            },
            child: Text('add admin')
            )
        ],
      ),
    );
  }
}