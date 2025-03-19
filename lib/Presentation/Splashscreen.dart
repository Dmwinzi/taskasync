import 'package:flutter/material.dart';
import 'package:task_async/Presentation/home.dart';
import 'dart:math' as math;
import 'Widgets/Stickynote.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() =>
      _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _peelProgress1 = 0.0;
  double _peelProgress2 = 0.0;
  int _peelStage = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        if (_peelStage == 1) {
          _peelProgress1 = _controller.value;
        } else if (_peelStage == 2) {
          _peelProgress2 = _controller.value;
        }
      });
    });

    _controller.forward().whenComplete(() {
      setState(() {
        _peelStage = 2;
        _controller.reset();
        _controller.forward();
      });

      _controller.forward().whenComplete(() {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home ()),
          );
        });
      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Task Manager",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [

                if (_peelStage >= 2)
                  Transform.rotate(
                    angle: math.pi / 30,
                    child: StickyNote(
                      data: StickyNoteData(
                        tasks: [
                          Task(text: "Review PRs", isChecked: true),
                          Task(text: "Write Tests", isChecked: false),
                          Task(text: "Code Refactor", isChecked: false),
                        ],
                        color: Colors.green[300]!,
                      ),
                    ),
                  ),

                if (_peelStage >= 1)
                  Transform.rotate(
                    angle: math.pi / 20,
                    child: ClipPath(
                      clipper: StickyNotePeelClipper(progress: (_peelStage == 2) ? _peelProgress2 : 0),
                      child: StickyNote(
                        data: StickyNoteData(
                          tasks: [
                            Task(text: "Standup Meeting", isChecked: true),
                            Task(text: "Prepare Presentation", isChecked: true),
                            Task(text: "Project Planning", isChecked: false),
                          ],
                          color: Colors.orange[300]!,
                        ),
                      ),
                    ),
                  ),

                if (_peelStage == 1)
                  Transform.rotate(
                    angle: math.pi / 40,
                    child: ClipPath(
                      clipper: StickyNotePeelClipper(progress: _peelProgress1),
                      child: StickyNote(
                        data: StickyNoteData(
                          tasks: [
                            Task(text: "Send Emails", isChecked: true),
                            Task(text: "Update Documentation", isChecked: false),
                            Task(text: "Schedule Meeting", isChecked: false),
                          ],
                          color: Colors.yellow[300]!,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StickyNoteData {
  final List<Task> tasks;
  final Color color;

  StickyNoteData({required this.tasks, required this.color});
}

class Task {
  final String text;
  final bool isChecked;

  Task({required this.text, required this.isChecked});
}

class StickyNotePeelClipper extends CustomClipper<Path> {
  final double progress;

  StickyNotePeelClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    if (progress <= 0.0) {
      path.addRect(Rect.fromLTWH(0, 0, width, height));
    } else if (progress >= 1.0) {
      path.addRect(Rect.fromLTWH(0, 0, 0, 0));
    } else {
      final peelHeight = height * progress;
      final controlPointOffset = peelHeight * 0.5;
      final endPointOffset = peelHeight * 0.2;

      path.lineTo(0, 0);
      path.lineTo(width, 0);
      path.lineTo(width, height - peelHeight);
      path.quadraticBezierTo(
        width * 0.9,
        height - peelHeight * 1.5 + controlPointOffset,
        width * 0.8,
        height - peelHeight + 10 + endPointOffset,
      );
      path.lineTo(width * 0.1, height + 10);
      path.lineTo(0, height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}