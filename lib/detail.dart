import 'package:flutter/material.dart';

class MyDetailPage extends StatefulWidget {
  final String title;
  const MyDetailPage({super.key, required this.title});

  @override
  State<MyDetailPage> createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // ปุ่มจะเคลื่อนจากล่างขึ้นกลางจอ
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    Navigator.pop(context); // กดแล้วกลับหน้า Home
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                bottom: 50 + _animation.value * (screenHeight / 2 - 50),
                left: MediaQuery.of(context).size.width / 2 - 60,
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: FloatingActionButton(
                    onPressed: _onButtonPressed,
                    backgroundColor: Colors.white,
                    child: Hero(
                      tag: 'evernight-hero',
                      child: ClipOval(
                        child: Image.asset(
                          'evernight1.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          ),
    ),
    ),
  ),
),
              );
            },
          ),
        ],
      ),
    );
  }
}
