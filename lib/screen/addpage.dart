// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Screenadd extends StatefulWidget {
  const Screenadd({Key? key}) : super(key: key);

  @override
  State<Screenadd> createState() => _ScreenaddState();
}

class _ScreenaddState extends State<Screenadd> {
  List<TextEditingController> listcontroller = [TextEditingController()];
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 15),

          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                'CREATE YOUR SCHEDULE',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.065,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins', // Change font to Poppins
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Image.asset('assets/image/TM pic 2.jpg')),
              SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Date: ',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: Icon(Icons.calendar_month_outlined))
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                      style: TextStyle(color: Colors.black),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Tasks',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                itemCount: listcontroller.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 15, right: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                          ),
                          child: Row(
                            children: [
                              Text('Task '),
                              Text((index + 1).toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 50,
                                          child: TextFormField(
                                            controller: listcontroller[index],
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              hintText: 'Start Time',
                                              hintStyle: GoogleFonts
                                                  .poppins(), // Poppins font for hint text
                                            ),
                                            style: GoogleFonts
                                                .poppins(), // Poppins font for input text
                                            onTap: () {
                                              _selectStartTime(context, index);
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 50,
                                          child: TextFormField(
                                            controller: listcontroller[index],
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              hintText: 'End Time',
                                              hintStyle: GoogleFonts
                                                  .poppins(), // Poppins font for hint text
                                            ),
                                            style: GoogleFonts
                                                .poppins(), // Poppins font for input text
                                            onTap: () {
                                              _selectEndTime(context, index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 50,
                                          child: TextFormField(
                                            controller: listcontroller[index],
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                borderSide: BorderSide(
                                                    color: Colors.black),
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 110,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    listcontroller[index].clear();
                                    listcontroller[index].dispose();
                                    listcontroller.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _addTask();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 80,
                          //padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Add +',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        _saveTasks();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 80,
                        // padding:
                        //EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,

              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context, int index) async {
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTime != null) {
      setState(() {
        _startTime = startTime;
        listcontroller[index].text = '${_startTime.hour}:${_startTime.minute}';
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context, int index) async {
    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (endTime != null) {
      setState(() {
        _endTime = endTime;
        listcontroller[index].text = '${_endTime.hour}:${_endTime.minute}';
      });
    }
  }

  void _addTask() {
    setState(() {
      listcontroller.add(TextEditingController());
    });
  }

  void _saveTasks() {
    // Implement saving tasks logic here
  }
}
