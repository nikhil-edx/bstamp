import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  final List<dynamic> pages = [
    //   StampClass(),
    //   DataTableExample(),
    //   Addstamp(), Account()
    Container(
      child: Center(
        child: Text("data"),
      ),
    ),
    Container(
      child: Center(
        child: Text("data"),
      ),
    ),
    Container(
      child: Center(
        child: Text("data"),
      ),
    ),
    Container(
      child: Center(
        child: Text("data"),
      ),
    )
  ];
  void initState() {
    super.initState();
    //  _profile();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // leading:
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset('assets/Images/edeXa_logo.png',
              cacheHeight: 30, color: const Color(0xffff005397)),
        ),
        elevation: 0,
        backgroundColor: Colors.white,

        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Nikhil Deshmukh",
                style: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.w900,
                    color: Color(0xffff005397)),
              ),
              Text(
                "n.deshmukh@edexa.com",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xffff005397)),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: Color(0xffff005397),
                ),
              )),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).copyWith().size.height,
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w900, color: Colors.blue),
        onTap: _onItemTapped, // new
        currentIndex: _selectedIndex, // new
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Stamp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Electronic Signature',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.open_in_browser), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Add Stamp'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Account'),
        ],
        selectedItemColor: Color(0xffff005397),
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
 // appBar: AppBar(
              //   title: Padding(
              //     padding: const EdgeInsets.only(right: 10.0),
              //     child: Image.asset(
              //       'assets/Images/bStamp_new.png',
              //       height: 50,
              //       filterQuality: FilterQuality.medium,
              //       fit: BoxFit.fill,
              //     ),
              //   ),
              //   elevation: 0,
              //   backgroundColor: Color(0xF8F8F8), // Colors.grey[100],
              //   actions: [
              //     Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: CircleAvatar(
              //         radius: 20,
              //         backgroundImage: NetworkImage(
              //           profilePicture,
              //         ), //AssetImage('assets/Images/images.jpg'),
              //       ),
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           username == null ? "----" : username,
              //           //"Nikhil Deshmukh",
              //           style: TextStyle(fontSize: 14, color: Colors.black),
              //         ),
              //         Text(
              //           email == null ? "----" : email,
              //           // "n.deshmukh@edexa.com",
              //           style: const TextStyle(
              //               fontSize: 12,
              //               fontWeight: FontWeight.w900,
              //               color: Colors.grey),
              //         ),
              //       ],
              //     ),
              //     Padding(
              //         padding: const EdgeInsets.only(left: 20, right: 20),
              //         child: IconButton(
              //             onPressed: () => showDialog<String>(
              //                   context: context,
              //                   builder: (BuildContext context) => Dialog(
              //                     shape: const RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.all(
              //                             Radius.circular(10.0))),
              //                     child: SizedBox(
              //                       width: 50,
              //                       child: Wrap(
              //                         children: [
              //                           Wrap(
              //                             children: [
              //                               Container(
              //                                 decoration: const BoxDecoration(
              //                                     color: Color(
              //                                         0xffff073D83), // Colors.red,
              //                                     borderRadius:
              //                                         BorderRadius.only(
              //                                             topLeft:
              //                                                 Radius.circular(
              //                                                     10),
              //                                             topRight:
              //                                                 Radius.circular(
              //                                                     10))),
              //                                 padding: const EdgeInsets.all(20),
              //                                 child: const Center(
              //                                   child: Icon(
              //                                     Icons.error_outline_sharp,
              //                                     color: Colors.white,
              //                                     size: 40,
              //                                   ),
              //                                 ),
              //                               ),
              //                               //  const Divider(),
              //                             ],
              //                           ),
              //                           Padding(
              //                             padding:
              //                                 const EdgeInsets.only(top: 20.0),
              //                             child: Wrap(
              //                               children: const [
              //                                 Center(
              //                                     child:
              //                                         Text('Are you sure ?')),
              //                               ],
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.all(20.0),
              //                             child: Row(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.center,
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.center,
              //                               children: [
              //                                 OutlinedButton(
              //                                     onPressed: () =>
              //                                         Navigator.pop(
              //                                             context, 'Cancel'),
              //                                     child: const Text('cancel')),
              //                                 const SizedBox(
              //                                   width: 20,
              //                                 ),
              //                                 OutlinedButton(
              //                                   onPressed: () async {
              //                                     SharedPreferences prefs =
              //                                         await SharedPreferences
              //                                             .getInstance();
              //                                     prefs.remove('token');
              //                                     prefs.remove('secretId');
              //                                     prefs.remove('secretId');
              //                                     //  Navigator.pushNamed(context, "/");
              //                                     Navigator.pushReplacement(
              //                                         context,
              //                                         MaterialPageRoute(
              //                                           builder: (context) =>
              //                                               SearchPage(), //edexaLogin()
              //                                           //LoginPage(),
              //                                         ));
              //                                   },
              //                                   child: const Text(
              //                                     'Logout',
              //                                     style: TextStyle(
              //                                         color: Colors.red),
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //             icon:
              //                 Image.asset("assets/Images/logout_button.png"))),
              //   ],
              // ),