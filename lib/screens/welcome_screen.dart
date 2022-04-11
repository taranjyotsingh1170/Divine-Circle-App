//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const routeName = '/welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> _imageList = [
      'assets/welcome_images/1.png',
      'assets/welcome_images/2.png',
      'assets/welcome_images/3.png',
    ];

    final List<String> _imageText = [
      'Never miss a deadline with management tools',
      'Stay connected with members',
      'Access to paaths and various resources',
    ];

    Widget buildImage(String image) {
      return SizedBox(
        // margin: const EdgeInsets.symmetric(horizontal: 15),
        //color: Colors.grey,
        child: Image.asset(image),
      );
    }

    Widget buildIndicator() {
      //print(_activeIndex);
      return AnimatedSmoothIndicator(
        activeIndex: _activeIndex,
        count: _imageList.length,
        effect: ScrollingDotsEffect(
          activeDotScale: 1.3,
          dotHeight: 10,
          dotWidth: 10,
          activeDotColor: Theme.of(context).primaryColor,
        ),
      );
    }

    // Widget buildText(String text) {
    //   return Expanded(
    //     child: ListView.builder(
    //       itemBuilder: (context, _activeIndex) =>
    //           Text(text),
    //       itemCount: _imageText.length,
    //     ),
    //   );
    // }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Divine Circle'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                  itemCount: _imageList.length,
                  itemBuilder: (context, index, realIndex) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildImage(_imageList[index]),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          _imageText[index],
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  options: CarouselOptions(
                    height: 400,
                    //autoPlay: _activeIndex == 2? false : true,
                    //autoPlayAnimationDuration: const Duration(seconds: 4),
                    //enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (pageIndex, reason) {
                      setState(() {
                        _activeIndex = pageIndex;
                      });
                      //print('Active index is - $_activeIndex');
                    },
                  ),
                ),
                //const SizedBox(height: 20),
                // Expanded(
                //   child: ListView.builder(
                //     itemBuilder: (context, _activeIndex) => Text(_imageText[_activeIndex]),
                //     itemCount: _imageText.length,
                //   ),
                // ),
                //const SizedBox(height: 20),
                buildIndicator(),
              ],
            ),
          ),
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
                  primary: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.083,
              ), //const SizedBox(height: 70),
            ],
          ),
        ],
      ),
    );
  }
}
