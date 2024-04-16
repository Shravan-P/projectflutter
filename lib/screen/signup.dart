// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_scheduler/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:time_scheduler/screen/mainhome/mainhomenav.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuthService();

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.09,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Sign  Up',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              children: [
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Username'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Email'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Password'),
                ),
                //const SizedBox(
                //height: 15,
                //),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: ElevatedButton(
              onPressed: _signup,
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  fixedSize: Size(150, 50),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              child: const Text('Create'),
            ),
          ),
        ]),
      ),
    ));
  }

  goToHome(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const Screenmainhome()));

  Future<void> addUserDetails(String uid, String userName, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'user name': userName,
      'email': email,
    });
  }

  _signup() async {
    final user =
        await _auth.signUpWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User created successfully");
      addUserDetails(user.uid, _username.text,
          _email.text); // Pass user.uid as the first argument
      goToHome(context);
    }
  }
}
