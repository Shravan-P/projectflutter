// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:time_scheduler/screen/mainhome/mainhomenav.dart';
import 'package:time_scheduler/screen/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class Screenlogin extends StatelessWidget {
  const Screenlogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.asset(
                            'assets/image/White logo.png',
                            fit: BoxFit.cover,
                            height: 350,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        loginindetails('Username', false),
                        const SizedBox(
                          height: 10,
                        ),
                        loginindetails('Password', true),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Dont have an account ?',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Screensignup()));
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
                            /*Text(
                        'Sign up',
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      )*/
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Screenmainhome()));
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                fixedSize: Size(150, 50),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            child: const Text('Login'),
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
      ),
    );
  }

  TextField loginindetails(String hint, bool obs) {
    return TextField(
      obscureText: obs,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: hint,
      ),
    );
  }
}
