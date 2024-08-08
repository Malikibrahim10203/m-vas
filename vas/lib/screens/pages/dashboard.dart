import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/widgets/components.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  var size;
  var widthScreen, heightScreen;

  int currentIndex = 0;

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;

    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width * 1,
              height: 165,
              decoration: BoxDecoration(
                  color: bluePrimary,
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg-db.png"),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
              ),
              child: Container(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  height: 70,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/images/user.png",),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Good Morning!",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Jhon Due",
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "PT. Digital Logistik Internasional\nBranch Jakarta",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.notifications_active,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(15),
                width: size.width * 1,
                height: 650,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: size.width * 0.9,
                      height: size.height * 0.13,
                      padding: EdgeInsets.only(top: heightScreen * 0.03),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/box-seal-db.png"),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: greyColor6,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "data",
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "data",
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: greyColor6,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "data",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "data",
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CertificateStatusNotActive(heightScreen, widthScreen),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Quick Action",
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        MenuActive(),
                        SizedBox(height: 3,),
                        Menu("assets/images/emet.png","Stamp e-Materai"),
                        SizedBox(height: 3,),
                        Menu("assets/images/tera.png","Stamp Tera"),
                        SizedBox(height: 3,),
                        Menu("assets/images/recap.png","Recapitulation"),
                        SizedBox(height: 3,),
                        Menu("assets/images/contact-us.png","Contact Us"),
                        SizedBox(height: 3,),
                      ],
                    )
                  ],
                )
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(15),
              width: size.width * 1,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activity History",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Text(
                          "view all",
                          style: TextStyle(
                              color: primaryColor2,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Stack(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/history.png",
                            width: 100,
                          ),
                          Text(
                            "No Activity History",
                            style: TextStyle(
                                color: Colors.black12
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          // Handle FAB press
        },
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              color: Color(0xff0081F1),
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Icon(
            Icons.file_upload_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        backgroundColor: Color(0xffEFF5FF),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAppBar(0, Icons.home, "Home"),
            SizedBox(width: 5),
            _bottomAppBar(1, Icons.folder, "Document"),
            SizedBox(width: 48), // Space for the FAB
            _bottomAppBar(2, Icons.chat_outlined, "Chat"),
            SizedBox(width: 5),
            _bottomAppBar(3, Icons.settings, "Setting"),
          ],
        ),
      ),
    );
  }
  Widget _bottomAppBar(item,icon,text) {
    return GestureDetector(
      onTap: () => _onItemTapped(item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: item!=_selectedIndex?greyColor3:primaryColor2,
          ),
          Text(
            "${text}",
            style: TextStyle(
              color: item!=_selectedIndex?greyColor3:primaryColor2,
            ),
          ),
        ],
      ),
    );
  }
  // Menu NotActive
  Widget Menu(logo,name) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 20,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: greyColor6,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Image.asset(logo),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${name}'),
            ],
          ),
        ),
    );
  }
}
