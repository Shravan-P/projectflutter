// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_scheduler/screen/login.dart';

class Screenprofile extends StatelessWidget {
  Screenprofile({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Text(
              'No data found'); // Handle the case where no data is available
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          /*appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            toolbarHeight: 100,
            title: Padding(
              padding: const EdgeInsets.only(top: 60), // Reduce top padding
              child: Text(
                'PROFILE',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins', // Change font to Poppins
                ),
              ),
            ),
            centerTitle: true,
          ),*/
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins', // Change font to Poppins
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  profileBoxes('Username: ', userData['user name']),
                  verticalSpace(),
                  profileBoxes('Email: ', userData['email']),
                  verticalSpace(),
                  GestureDetector(
                    onTap: () async {
                      await _auth.signOut();
                      goToLogin(context);
                    },
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Logout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    18), // Increase font size if necessary
                          ),
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox verticalSpace() {
    return const SizedBox(
      height: 10, // Reduce vertical space
    );
  }

  Container profileBoxes(String cardName, String cardDetails) {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cardName,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            cardDetails,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Screenlogin()),
      );
}
