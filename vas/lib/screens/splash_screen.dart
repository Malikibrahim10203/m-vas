import 'package:flutter/material.dart';
import 'package:vas/widgets/logovas.dart';
import 'package:vas/widgets/onboarding.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var size;

  final controller = OnboardingData();
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoVas(size.height * 0.15),
            SizedBox(
              height: 20,
            ),
            ImageSplash("splash-1", size.height * 0.3),
            SizedBox(
              height: 50,
            ),
            TextSplash(
              "Stamp E-Materai", "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor.",
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: size.height * 0.075,
              width: size.width * 0.8,
              child: ElevatedButton(
                onPressed: (){},
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (){
                print("Success");
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: Color(0xff054BA6)
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
