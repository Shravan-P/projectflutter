import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_scheduler/screen/schedulepage.dart';

class Screenadd extends StatefulWidget {
  const Screenadd({Key? key}) : super(key: key);

  @override
  State<Screenadd> createState() => _ScreenaddState();
}

class _ScreenaddState extends State<Screenadd> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<String> taskNames = [];
  final List<TextEditingController> _controllers = [];
  String? generatedSchedule; // Add this line
  bool isLoading = false; // Add this line

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Schedule'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: Icon(Icons.calendar_today),
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Start Time:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _selectStartTime(context);
                        },
                        child: Text(
                          _startTime != null
                              ? _startTime!.format(context)
                              : 'Select Time',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select End Time:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _selectEndTime(context);
                        },
                        child: Text(
                          _endTime != null
                              ? _endTime!.format(context)
                              : 'Select Time',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Tasks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: taskNames.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 13),
                        child: TextFormField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            labelText: 'Task Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteTask(index);
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                      color: Colors.red,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addTask();
                  },
                  child: Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveAndGenerateSchedule();
                },
                child: Text(
                  'Generate',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 78, 136),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
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

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _addTask() {
    setState(() {
      TextEditingController controller = TextEditingController();
      controller.addListener(() {
        final index = _controllers.indexOf(controller);
        if (index != -1 && index < taskNames.length) {
          taskNames[index] =
              controller.text; // Update the corresponding task name
        }
      });
      _controllers.add(controller);
      taskNames.add(''); // Add an empty task name
    });
  }

  void _deleteTask(int index) {
    setState(() {
      if (index >= 0 && index < taskNames.length) {
        _controllers[index].dispose(); // Dispose of the controller
        _controllers.removeAt(index);
        taskNames.removeAt(index);
      }
    });
  }

  void _saveAndGenerateSchedule() async {
    if (_selectedDate == null ||
        _startTime == null ||
        _endTime == null ||
        taskNames.isEmpty) {
      _showValidationError('Please fill in all the fields.');
      return;
    }

    // Convert TimeOfDay to DateTime for comparison
    DateTime startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    DateTime endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      _showValidationError('End time must be after start time.');
      return;
    }

    // Calculate the total duration available for tasks
    Duration totalDuration = endDateTime.difference(startDateTime);

    // Calculate the total time needed for all tasks and mindful exercises
    int totalTaskTime = taskNames.length * 60; // 1 hour per task
    int totalMindfulExerciseTime =
        taskNames.length * 5; // 5 minutes per exercise
    int totalRequiredTime = totalTaskTime + totalMindfulExerciseTime;

    // Check if there's enough time for all tasks and mindful exercises
    if (totalRequiredTime > totalDuration.inMinutes) {
      _showValidationError(
          'Not enough time for all tasks and mindful exercises.');
      return;
    }

    // Calculate the number of mindful exercises needed
    int numMindfulExercises = taskNames.length - 1;

    // Generate random times for mindful exercises
    List<int> exerciseTimes = [];
    Random random = Random();
    for (int i = 0; i < numMindfulExercises; i++) {
      int randomMinutes =
          random.nextInt(totalDuration.inMinutes - totalRequiredTime);
      exerciseTimes.add(randomMinutes);
    }
    exerciseTimes.sort();

    // Generate the schedule
    String schedule = '';
    DateTime currentDateTime = startDateTime;
    for (int i = 0; i < taskNames.length; i++) {
      // Task start time
      schedule += '${DateFormat('hh:mm a').format(currentDateTime)} - ';

      // Task end time
      DateTime taskEndTime = currentDateTime.add(Duration(minutes: 60));
      schedule +=
          '${DateFormat('hh:mm a').format(taskEndTime)}: Task: ${taskNames[i]}\n';

      // Insert mindful exercise before each task except the last one
      if (i < numMindfulExercises) {
        // Duration for mindful exercise in minutes
        schedule +=
            'Mindful exercise (5 or 10 mins): ${_randomMindfulExercise()}\n\n';

        // Adjust currentDateTime for the next task or exercise
        currentDateTime = taskEndTime.add(Duration(minutes: exerciseTimes[i]));
      } else {
        // If this is the last task, check if there's extra time available
        if (i == taskNames.length - 1 &&
            totalDuration.inMinutes - totalRequiredTime > 0) {
          schedule +=
              'You have completed all tasks. Enjoy the rest of the day doing things you like. You spent the day productively.';
        }
      }
    }

    // Show success dialog
    _showScheduleDialog(schedule);

    // Navigate to SchedulePage with the generated schedule

    // Save the schedule to Firestore
    await FirebaseFirestore.instance.collection('schedules').add({
      'date': _selectedDate,
      'schedule': schedule,
    });

    // Reset the screen to default state
    _resetState();
  }

// Helper function to select a random mindful exercise
  String _randomMindfulExercise() {
    List<String> mindfulExercises = [
      'Deep Breathing',
      'Mindful Stretching',
      'Mindful Walking',
      'Quick Meditation',
      'Mindful Eating',
      'Visualization',
      'Gratitude Practice',
      'Progressive Muscle Relaxation',
      'Breath Counting',
      'Desk Yoga',
    ];
    Random random = Random();
    return mindfulExercises[random.nextInt(mindfulExercises.length)];
  }

  void _showValidationError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showScheduleDialog(String schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Schedule generated successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetState() {
    setState(() {
      _selectedDate = DateTime.now();
      _startTime = null;
      _endTime = null;
      taskNames.clear();
      _controllers.forEach((controller) => controller.clear());
      _controllers.clear();
    });
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.Hm().format(dateTime);
  }
}
