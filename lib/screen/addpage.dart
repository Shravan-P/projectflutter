// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Screenadd extends StatefulWidget {
  const Screenadd({Key? key}) : super(key: key);

  @override
  State<Screenadd> createState() => _ScreenaddState();
}

class _ScreenaddState extends State<Screenadd> {
  List<TextEditingController> listcontroller = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25), // Add padding here
              child: Image.asset(
                'assets/image/TM pic 1.jpg',
                height: 200,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Create Your Schedule',
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              shrinkWrap: true,
              itemCount: listcontroller.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          child: TextFormField(
                            controller: listcontroller[index],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: 'task name',
                              hintStyle: GoogleFonts
                                  .poppins(), // Poppins font for hint text
                            ),
                            style: GoogleFonts
                                .poppins(), // Poppins font for input text
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            listcontroller[index].clear();
                            listcontroller[index].dispose();
                            listcontroller.removeAt(index);
                          });
                        },
                        child: Icon(Icons.delete),
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  listcontroller.add(TextEditingController());
                });
              },
              child: Center(
                child: Container(
                  child: Text('add+'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
