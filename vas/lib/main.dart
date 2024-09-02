import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/credential.dart';
import 'package:vas/screens/auth/change_password.dart';
import 'package:vas/screens/auth/forget_password.dart';
import 'package:vas/screens/auth/login.dart';
import 'package:vas/screens/auth/otp_code.dart';
import 'package:vas/screens/e-Kyc/activate_account.dart';
import 'package:vas/screens/get_started.dart';
import 'package:vas/screens/pages/dashboard.dart';
import 'package:vas/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:vas/widgets/wait_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  void initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }

      linkStream.listen((String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      });
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void _handleDeepLink(String link) {
    print('Received deep link: $link');
    final uri = Uri.parse(link);
    print('Parsed URI: $uri');
    if (link.contains('forgot-password')) {
      final itemId = uri.queryParameters['t'];
      print('Item ID: $itemId');
      _navigatorKey.currentState?.pushNamed('/change_otp', arguments: itemId);
    } else if (link.contains('registrationKYC')) {
      final itemId = uri.queryParameters['token'];
      print('Token: $itemId');
      _navigatorKey.currentState?.pushNamed('/activate_account', arguments: itemId);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FutureBuilder(
        future: EventPref.getCredential(),
        builder: (context, AsyncSnapshot<Credential?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return SplashScreen();
          } else {
            final token = snapshot.data!.data.token;
            return Dashboard(token: token);
          }
        },
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/change_otp') {
          final args = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => ChangePassword(token: args),
          );
        } else if (settings.name == '/activate_account') {
          final args = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<Credential?>(
              future: EventPref.getCredential(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Login(); // Redirect to login if not logged in
                } else {
                  final token = settings.arguments as String?;
                  return ActivateAccount(token: token);
                }
              },
            ),
          );
        }
        return null;
      },
      routes: {
        '/GetStarted': (context) => const GetStarted(),
        '/Login': (context) => const Login(),
        '/ForgetPassword': (context) => const ForgetPassword(),
        '/OtpCode': (context) => const OtpCode(),
        '/Wait': (context) => const WaitScreen(),
      },
    );
  }
}
