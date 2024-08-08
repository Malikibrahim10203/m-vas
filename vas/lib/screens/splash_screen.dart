import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/screens/auth/login.dart';
import 'package:vas/screens/get_started.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  var size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildPage(
            title: 'Stamp E-Materai',
            description: 'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor.',
            image: 'splash-1',
            sizing: 0.25,
          ),
          _buildPage(
            title: 'E-Sign',
            description: 'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor.',
            image: 'splash-3',
            sizing: 0.30,
          ),
          _buildPage(
            title: 'Organize File',
            description: 'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor.',
            image: 'splash-2',
            isLastPage: true,
            sizing: 0.40,
          ),
        ],
      ),
      bottomNavigationBar: _bottomSplash(),
    );
  }

  Widget _bottomSplash() {
    return Container(
      height: size.height * 0.18,
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: SlideEffect(
                offset:  16.0,
                type: SlideType.normal,
                dotWidth:  12.0,
                dotHeight:  12.0,
                spacing: 8.0,
                radius:  16,
                paintStyle:  PaintingStyle.fill,
                strokeWidth:  1.0,
                dotColor:  Colors.grey,
                activeDotColor:  Color(0xff0081F1)
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.85,
            child: ElevatedButton(
              onPressed: (){
                if (_pageController.page == 2) {
                  // Navigate to the home screen or main screen
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStarted()));
                } else {
                  _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
                }
              },
              child: Text(
                "Next",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0081F1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/GetStarted');
            },
            child: Text(
                "Skip"
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required String image, required String title, required String description, required double sizing, bool isLastPage = false}) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.04,
          ),
          Image.asset(
            "assets/images/vas-logo.png",
            width: size.height * 0.15,
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset(
            "assets/images/$image.png",
            width: size.height * sizing,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
              "$title",
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              )
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "$description",
            style: GoogleFonts.poppins(
              color: Color(0xff929292),
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

