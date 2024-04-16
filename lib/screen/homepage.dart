import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Screenhome extends StatefulWidget {
  const Screenhome({Key? key}) : super(key: key);

  @override
  _ScreenhomeState createState() => _ScreenhomeState();
}

class _ScreenhomeState extends State<Screenhome> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Get the username from the user document
      setState(() {
        _userName = userData.data()?['user name'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: const Color.fromARGB(175, 0, 0, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        leading: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hi, ',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  _userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              DateFormat('dd MMM yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            iconSize: 30,
            color: Colors.white,
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need Some Motivation',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(176, 248, 230, 196),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30, top: 15),
                        child: Text(
                          'Books',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            listBook('1', 'Author Your Life'),
                            listBook('2', 'Its how you finish'),
                            listBook('3', 'You deserve this shit'),
                            listBook('4', 'Good day start with knowledge'),
                            listBook('5', 'Make your own happiness'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(176, 248, 230, 196),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30, top: 15),
                        child: Text(
                          'Movies',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            listMovie('1', 'Movie 1'),
                            listMovie('2', 'Movie 2'),
                            listMovie('3', 'Movie 3'),
                            // Add more movie entries as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding listBook(String val, String name) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 140,
              width: 90,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(1)),
                child: Image.asset(
                  'assets/image/BOOK$val.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Padding listMovie(String val, String name) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 140,
              width: 90,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(1)),
                child: Image.asset(
                  'assets/image/MOVIE$val.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
