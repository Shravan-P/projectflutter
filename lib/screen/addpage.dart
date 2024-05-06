import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        title: const Text('Generate Schedule'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Start Time:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _selectStartTime(context);
                        },
                        child: Text(
                          _startTime != null
                              ? _startTime!.format(context)
                              : 'Select Time',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select End Time:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _selectEndTime(context);
                        },
                        child: Text(
                          _endTime != null
                              ? _endTime!.format(context)
                              : 'Select Time',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Tasks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: taskNames.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 13),
                        child: TextFormField(
                          controller: _controllers[index],
                          decoration: const InputDecoration(
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
                      icon: const Icon(Icons.delete, color: Colors.red),
                      color: Colors.red,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addTask();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(5),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveAndGenerateSchedule();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 78, 136),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Generate',
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
    if (_startTime == null || _endTime == null || taskNames.isEmpty) {
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
        taskNames.length * 15; // 15 minutes per exercise
    int totalRequiredTime = totalTaskTime + totalMindfulExerciseTime;

    // Check if there's enough time for all tasks and mindful exercises
    if (totalRequiredTime > totalDuration.inMinutes) {
      _showValidationError(
          'Not enough time for all tasks and mindful exercises.');
      return;
    }

    // Calculate the number of mindful exercises needed
    int numMindfulExercises = taskNames.length;

    // Calculate the time interval between tasks and exercises
    int interval =
        (totalDuration.inMinutes - totalRequiredTime) ~/ numMindfulExercises;

    // Generate the schedule
    String schedule = '';
    DateTime currentDateTime = startDateTime;
    for (int i = 0; i < taskNames.length; i++) {
      // Task start time
      schedule += '${DateFormat('hh:mm a').format(currentDateTime)} - ';

      // Task end time
      DateTime taskEndTime = currentDateTime.add(const Duration(minutes: 60));
      schedule +=
          '${DateFormat('hh:mm a').format(taskEndTime)}:\nTask: ${taskNames[i]}\n';

      // Insert mindful exercise after each task except the last one
      if (i < taskNames.length - 1) {
        // Duration for mindful exercise in minutes
        schedule +=
            '\nMindful exercise (10 or 15 mins):\n${_randomMindfulExercise()}\n\n';

        // Adjust currentDateTime for the next task or exercise
        currentDateTime = taskEndTime.add(Duration(minutes: interval));
      } else {
        // If this is the last task, check if there's extra time available
        if (totalDuration.inMinutes - totalRequiredTime > 0) {
          schedule +=
              '\nYou have completed all tasks.\nEnjoy the rest of the day doing things you like.\nYou have spent the day productively.';
        }
      }
    }

    // Get the current user's email
    final currentUser = FirebaseAuth.instance.currentUser;
    final userEmail = currentUser?.email;

    // Show success dialog
    _showScheduleDialog(schedule);

    // Save the schedule to Firestore
    await FirebaseFirestore.instance.collection('schedules').add({
      'userEmail': userEmail,
      'date': _selectedDate,
      'schedule': schedule,
    });

    // Reset the screen to default state
    _resetState();
  }

// Helper function to select a random mindful exercise
  String _randomMindfulExercise() {
    List<String> mindfulExercises = [
      'Deep Breathing: Breathe in deeply and slowly through your nose, expanding your lower rib cage, and letting your abdomen (belly) move forward.Hold for a count of 3 to 5.Breathe out slowly and completely through pursed lips. Do not force your breath out.',
      'Play the sound game: Listen to the world around you. Identify eight sounds you hear, either from inside your body, in the room, or somewhere in the distance.',
      'Ground your feet: Place your feet flat on the ground — (even if you’re sitting). Inhale for three seconds, then exhale for three seconds. Concentrate on your breathing and your connection to the floor beneath your feet. ',
      'Practice introspection: Take a minute to sit still and evaluate each of your emotions in silence. Note which emotions are stronger. Ask yourself, "What do I feel?" rather than, "Why do I feel this way?" Be curious about your thoughts and emotions.',
      'Play the chime game: Do you have a bell or something that will make a light noise? Find a quiet spot and ring it only once; focus on the sound of the chime and listen until you cannot hear it anymore.',
      'Practice stillness: Staying still helps to slow you down. Focusing on one specific image or thought for as long as possible can help you sit still and calm down. ',
      'Follow your breathing: Deep breathing is one thing, but have you ever paid attention to how your body feels as your breath travels through your body? Find a comfortable position and slowly take a breath. Follow each breath. Notice where it starts, how it feels coming in through your nose, filling your chest, and exiting through your mouth. ',
      'Eat slowly: Challenge yourself to take 30 seconds to savor something like a strawberry or piece of chocolate. Acknowledge the smell, taste, and how it feels as you chew it.',
      'Play the name game: Look around your environment. Name three things you see, two you hear, and one you feel. This helps you become more aware of your surroundings.',
      'Walk outside: Sometimes, some fresh air is exactly what you need. If you can, go for a self-reflective walk or even just stick your head out a window. Let the fresh air seep into your lungs.',
      'Coloring and drawing: Try doodling on a blank page or coloring in a coloring book. This activity doesn’t have any rules, so have fun with it.',
      'Coloring and drawing: Try doodling on a blank page or coloring in a coloring book. This activity doesn’t have any rules, so have fun with it.',
      'Music therapy: Make or find a playlist of songs that are relaxing and easy to listen to. They do not have to only be classical or instrumental music either. These songs should help refocus your thoughts — the genre is up to you.',
      'Do a full-body scan: Get into a comfortable position, sitting or standing, and examine your body from head to toe. Check for pain, tingles, or even relaxing sensations. See if anywhere is sore and if you can relax those muscles.',
      'Box breathing technique: Box breathing is a breathing exercise where you breathe in for four counts, hold your breath for four counts, then breathe out for four counts. Hold that for four seconds, and start over. Draw a box in your mind as you count to stay grounded — four seconds per side.',
    ];
    Random random = Random();
    return mindfulExercises[random.nextInt(mindfulExercises.length)];
  }

  void _showValidationError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
          title: const Text('Success'),
          content: const Text('Schedule generated successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
      for (var controller in _controllers) {
        controller.clear();
      }
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
