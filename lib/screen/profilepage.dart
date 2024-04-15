// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class Screenprofile extends StatelessWidget {
  const Screenprofile({super.key});

  @override
  Widget build(BuildContext context) {
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
                fontFamily: 'Platypi'),
          ),
        ),
        centerTitle: true,
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
                verticalspace(),
                verticalspace(),
                profiephoto(),
                verticalspace(),
                verticalspace(),
                profileboxes('Name :', 'Users Name'),
                verticalspace(),
                profileboxes('Username :', 'Username'),
                verticalspace(),
                profileboxes('Email :', 'Users Email'),
                verticalspace(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox verticalspace() {
    return SizedBox(
      height: 15,
    );
  }

  Container profiephoto() {
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

  Container profileboxes(String cardname, String carddetails) {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cardname,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Text(carddetails, style: TextStyle(color: Colors.white, fontSize: 15))
        ],
      ),
    );
  }
}
