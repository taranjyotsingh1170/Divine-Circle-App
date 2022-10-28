import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class WelcomeScreenV1 extends StatefulWidget {
  const WelcomeScreenV1({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenV1> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreenV1>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  //bool logoAnimation = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    //logoAnimation = true;
    //repeatOnce();
  }

  // void repeatOnce() async {
  //   await _controller.forward();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Divine Circle'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
                child: const Text(
                  'Get started',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor
                  : Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 70)
            ],
          ),
          Center(
            child: AnimatedContainer(
              // constraints: BoxConstraints(
              //     maxHeight: MediaQuery.of(context).size.height * 0.5),
              //alignment: Alignment.bottomCenter,
              duration: const Duration(seconds: 2),
              height: 270,
              width: 270,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              //curve: Curves.easeIn,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset('assets/images/dc_logo.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
