import 'package:flutter/material.dart';
import 'package:time_scheduler/screen/addpage.dart';
import 'package:time_scheduler/screen/homepage.dart';
import 'package:time_scheduler/screen/profilepage.dart';
import 'package:time_scheduler/screen/progresspage.dart';
import 'package:time_scheduler/screen/schedulepage.dart';

class Screenmainhome extends StatefulWidget {
  const Screenmainhome({Key? key}) : super(key: key);

  @override
  State<Screenmainhome> createState() => _ScreenmainhomeState();
}

class _ScreenmainhomeState extends State<Screenmainhome> {
  int _currentSelectedindex = 0;
  get _pages => [
        const Screenhome(),
        const Screenschedule(),
        const Screenadd(),
        const Screenprogress(),
        Screenprofile()
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentSelectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 69, 60, 60),
        currentIndex: _currentSelectedindex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 152, 147, 147),
        showUnselectedLabels: true,
        elevation: 10,
        onTap: (newindex) {
          setState(() {
            _currentSelectedindex = newindex;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration_rounded), label: 'Schedule'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist_outlined), label: 'Progress'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
