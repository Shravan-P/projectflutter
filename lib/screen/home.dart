// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.white,
        /*shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),*/
        leading: Icon(
          Icons.menu_rounded,
          color: Colors.white,
        ),
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
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
                        'Name',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications),
                iconSize: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: 15,
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(left: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Some Motivation',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(176, 248, 230, 196),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 15),
                      child: Text(
                        'Books',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          listbook('1', 'Author Your Life'),
                          listbook('2', 'Its how you finish'),
                          listbook('3', 'You desreve this shit'),
                          listbook('4', 'Good day start with knowledge'),
                          listbook('5', 'Make your own happiness'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(176, 248, 230, 196),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 15),
                      child: Text(
                        'Movies',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          listbook('1', 'Author Your Life'),
                          listbook('2', 'Its how you finish'),
                          listbook('3', 'You desreve this shit'),
                          listbook('4', 'Good day start with knowledge'),
                          listbook('5', 'Make your own happiness'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
      bottomNavigationBar: navbar(context),
    );
  }

  Container navbar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          color: Color.fromARGB(176, 248, 230, 196),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.home_outlined,
                size: 30,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.app_registration_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline_rounded,
                size: 35,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.checklist_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person_outline_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding listbook(String val, String name) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 120,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 140,
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                child: Image.asset(
                  'image/BOOK$val.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: TextStyle(
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
