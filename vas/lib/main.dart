import 'package:flutter/material.dart';
import 'package:vas/screens/auth/change_password.dart';
import 'package:vas/screens/auth/forget_password.dart';
import 'package:vas/screens/auth/login.dart';
import 'package:vas/screens/auth/otp_code.dart';
import 'package:vas/screens/get_started.dart';
import 'package:vas/screens/pages/dashboard.dart';
import 'package:vas/screens/splash_screen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
      routes: {
        '/GetStarted': (context)=> const GetStarted(),
        '/Login': (context)=> const Login(),
        '/ForgetPassword': (context)=> const ForgetPassword(),
        '/OtpCode': (context)=> const OtpCode(),


        '/Dashboard': (context)=> const Dashboard(),
        // '/Document': (context)=> const Document(),
        // '/Chat': (context)=> const Dashboard(),
        // '/Setting': (context)=> const Dashboard(),
      },
    );
  }
}

