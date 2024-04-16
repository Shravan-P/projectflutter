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
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            toolbarHeight: 100,
            title: Padding(
              padding: const EdgeInsets.only(top: 10), // Reduce top padding
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
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20), // Apply padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileBoxes('Username: ', userData['user name']),
                  verticalSpace(),
                  profileBoxes('Email: ', userData['email']),
                  verticalSpace(),
                  SizedBox(
                    width: 250, // Adjust the width of the logout button
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20), // Apply padding
                      child: ElevatedButton(
                        onPressed: () async {
                          await _auth.signOut();
                          goToLogin(context);
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 18), // Increase font size if necessary
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                              color: Colors.red,
                              width: 2), // Add red border if necessary
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              cardName,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                cardDetails,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.left,
              ),
            ),
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
