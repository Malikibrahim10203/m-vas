import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/credential.dart';
import 'package:vas/models/users.dart';
import 'package:vas/screens/auth/change_password.dart';
import 'package:vas/screens/auth/forget_password.dart';
import 'package:vas/screens/auth/login.dart';
import 'package:vas/screens/auth/otp_code.dart';
import 'package:vas/screens/get_started.dart';
import 'package:vas/screens/pages/dashboard.dart';
import 'package:vas/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:vas/widgets/wait_screen.dart';

void main() {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
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
    if (link.contains('forgot-password')) {
      final uri = Uri.parse(link);
      final itemId = uri.queryParameters['t'];
      _navigatorKey.currentState?.pushNamed('/change_otp', arguments: itemId);
    } else {
      // Handle other links or default action
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
            // Tampilkan indikator pemuatan saat data sedang dimuat
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Tangani jika ada error saat memuat data
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            // Tampilkan SplashScreen jika data tidak ada
            return SplashScreen();
          } else {
            // Ambil token dari objek Credential dan kirimkan ke Dashboard
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
