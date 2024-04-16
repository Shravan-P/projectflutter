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
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text(
              'No data found'); // Handle the case where no data is available
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            toolbarHeight: 100,
            title: Padding(
              padding: EdgeInsets.only(top: 48),
              child: Text(
                'PROFILE',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Platypi',
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  await _auth.signOut();
                  goToLogin(context);
                },
                icon: Icon(Icons.logout),
              )
            ],
          ),
          body: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalSpace(),
                    verticalSpace(),
                    profilePhoto(),
                    verticalSpace(),
                    verticalSpace(),
                    profileBoxes('Username :', userData['user name']),
                    verticalSpace(),
                    profileBoxes('Email :', userData['email']),
                    verticalSpace(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox verticalSpace() {
    return SizedBox(
      height: 15,
    );
  }

  Container profilePhoto() {
    return Container(
      height: 300,
      width: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Image.asset(
          'assets/image/profile_photo.jpg',
          fit: BoxFit.cover,
        ),
      ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cardName,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            cardDetails,
            style: TextStyle(color: Colors.white, fontSize: 15),
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
