import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/screens/auth/forget_password.dart';
import 'package:vas/widgets/components.dart';
import 'package:vas/widgets/logovas.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _isChecked = false;

  bool passwordVisible=false;

  var size;
  var widthScreen, heightScreen;

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;

    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height * 0.07
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoVas(size.width * 0.25),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back",
                        style: GoogleFonts.poppins(
                          color: Color(0xff4B4B4B),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Image.asset("assets/images/bye.png", width: 35.0,),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please enter your account",
                    style: GoogleFonts.poppins(
                        color: Color(0xff717171),
                        fontSize: 12
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 350,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Text("*", style: TextStyle(color: Colors.red),),
                                Text(
                                  " Email",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff4F4747),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                            height: size.height * 0.065,
                            width: size.width * 1,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1,color: Color(0xffB8B8B8)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            )
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("*", style: TextStyle(color: Colors.red),),
                                Text(
                                  " Password",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff4F4747),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, "/ForgetPassword");
                              },
                              child: Text(
                                "Forgot Password",
                                style: GoogleFonts.roboto(
                                    color: indigoColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                            height: size.height * 0.065,
                            width: size.width * 1,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                          () {
                                        passwordVisible = !passwordVisible;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: passwordVisible,
                            )
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false; // Update the state
                                });
                              },
                            ),
                            Text(
                              'Remember Me',
                              style: GoogleFonts.roboto(
                                fontSize: 12
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _bottomLogin(),
    );
  }

  Widget _bottomLogin() {
    return Container(
      height: size.height * 0.12,
      child: Column(
        children: [
          Container(
            height: size.height * 0.06,
            width: size.width * 0.85,
            child: ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, "/Dashboard");
              },
              child: Text(
                "Login",
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
        ],
      ),
    );
  }
}
