import 'dart:convert';
import 'dart:io';
import 'package:bStamp/bottom_Navigation/appbar.dart';
import 'package:crypto/crypto.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'backend.dart';
import 'bottom_Navigation/dialog_toast.dart';
import 'bottom_Navigation/stampeddocument.dart';

class ValidatePage extends StatefulWidget {
  @override
  _ValidatePageState createState() => _ValidatePageState();
}

class _ValidatePageState extends State<ValidatePage> {
  var color1 = Colors.black, color = Colors.black;
  @override
  void initState() {
    super.initState();
    checkIsLogin();
    _getStampList();
  }

  var dataaa, dirpaths;
  List selectedUserss = [];
  List<dynamic> hashList = [];
  List<dynamic> dataList = [];
  var pageImage, pageImagee;
  String filename;
  List<dynamic> filenameList = [];
  int validation = 0;
  var hash1;
  List Index = [];
  _getStampList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');

    var url = Uri.parse("https://${Backend.baseurl}/user-profile");

    var response = await http.get(
      url,
      headers: <String, String>{
        //  HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: token
      },
    );
    var jsonResponse = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = convert.jsonDecode(response.body);
        // ignore: avoid_print

        preferences.setString('email', jsonResponse['data']['email']);
        preferences.setString('username', jsonResponse['data']['username']);
        preferences.setString(
            'name',
            jsonResponse['data']['first_name'] +
                jsonResponse['data']['last_name']);
        preferences.setString(
            'profilePicture', jsonResponse['data']['profilePic']);
        preferences.setString(
            "viewType", jsonResponse['data']['viewType'].toString());
        preferences.setString(
            "watermark", jsonResponse['data']['watermark'].toString());
        preferences.setString(
            "align", jsonResponse['data']['align'].toString());
        _getUserInfo();
      });
    } else {
      var jsonResponse = convert.jsonDecode(response.body);

      // ignore: avoid_print

    }
  }

  final searchbar = TextEditingController();
  var focusNode = FocusNode();
  var token, email, name, username, profilePicture;
  checkIsLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    if (token != null && token != '') {
      setState(() {
        token = token;
      });
      // ignore: avoid_print

      _getUserInfo();
    } else {
      // ignore: avoid_print

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => SearchPage(), //edexaLogin() // LoginPage(),
      //     ));
    }
  }

  _getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      email = preferences.getString(
        'email',
      );
      name = preferences.getString(
        'name',
      );
      username = preferences.getString(
        'username',
      );
      profilePicture = preferences.getString(
        'profilePicture',
      );
    });
  }

  Offset offset;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Lato',
          // textTheme:
          //  GoogleFonts.latoTextTheme(
          //   // headline1: GoogleFonts.lato(textStyle: textTheme.headline1),
          //   Theme.of(context).textTheme,
          // ),
        ),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Container(
                            color: Colors.white,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, right: 0),
                                child: RawKeyboardListener(
                                  focusNode: focusNode,
                                  onKey: (event) {
                                    if (event.isKeyPressed(
                                        LogicalKeyboardKey.enter)) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StampedDocument(
                                                    id: searchbar.text.trim(),
                                                  ) // LoginPage(),
                                              ));
                                    }
                                  },
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 25),
                                    cursorColor: Colors.black,
                                    controller: searchbar,
                                    decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          Icons.search,
                                          size: 45,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Search and hit enter",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        )),
                                    textInputAction: TextInputAction.search,
                                  ),
                                )
                                // ),
                                )),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        "OR",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    //_divider(),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, left: 5.0, right: 5.0),
                      child: DottedBorder(
                        color: Colors.grey.shade400,
                        strokeWidth: 1,
                        strokeCap: StrokeCap.round,
                        dashPattern: [5],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        child: DropTarget(
                          onDragDone: (detail) {
                            setState(() {
                              final c = detail.urls[0].path;
                              String d = c.replaceFirst("/", "");

                              final bytes = File("${d.replaceAll("%20", " ")}")
                                  .readAsBytesSync();
                              final uri = lookupMimeType(c);

                              String base64Image =
                                  "data:$uri;base64," + base64Encode(bytes);

                              //  hash(base64Image, filename);
                            });
                          },
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _openFileExplorer();
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width / 11,
                              width: MediaQuery.of(context).size.width / 1.7,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey.shade100.withOpacity(0.7),
                                // color: Colors.white //Colors.grey[200],
                              ),
                              child: Center(
                                  child: filename == null
                                      ? const Text(
                                          "Drop your file or click here",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 25,
                                          ))
                                      : Text(
                                          "$filename",
                                          style: TextStyle(fontSize: 25),
                                        )),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    dataList.length == 0 || dataaa == null
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Stamp Status",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      // fontWeight: FontWeight.w900,
                                      color: Colors.black),
                                ),
                                Spacer(),
                                ElevatedButton.icon(
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          Size.fromHeight(20),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xffff073d83)),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(10))),
                                    onPressed: () {
                                      setState(() {
                                        //dataaa.clear();
                                        dataaa = null;
                                        hashList.clear();
                                        selectedUserss.clear();
                                        filenameList.clear();
                                        // dataList.remove(dataList.length);
                                      });
                                    },
                                    icon: const Icon(Icons.clear),
                                    label: const Text("Clear All")),
                                SizedBox(width: 10),
                                selectedUserss.length > 1
                                    ? ElevatedButton.icon(
                                        style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                              Size.fromHeight(20),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xffff073d83)),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(10))),
                                        onPressed: () {
                                          if (token != null && token != '') {
                                            for (int i = 0;
                                                i < filenameList.length;
                                                i++) {
                                              //  updateAlbum1(i);
                                            }
                                          } else {
                                            Dailog_toast().showError(context,
                                                "You need to login to access this features");
                                          }
                                        },
                                        icon: Image.asset(
                                          "assets/Images/stamp_white.png",
                                          height: 20,
                                        ), //const Icon(Icons.ac_unit),
                                        label: const Text("Add All To Stamp"))
                                    : SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                selectedUserss.length > 1
                                    ? ElevatedButton.icon(
                                        style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                              const Size.fromHeight(20),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color(0xffff073d83)),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(10))),
                                        onPressed: () {
                                          if (token != null && token != '') {
                                            // showWatermark(context, filename,
                                            //     hash, selectedUserss.length);
                                          } else {
                                            Dailog_toast().showError(context,
                                                "You need to login to access this features");
                                          }
                                        },
                                        icon: Image.asset(
                                          "assets/Images/table_white.png",
                                          height: 20,
                                        ), //const Icon(Icons.ac_unit),
                                        label: const Text(
                                            "Add All To Stamp with MetaData"))
                                    : SizedBox()
                              ],
                            ),
                          ),
                  ],
                )),
          ),
        ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  String _fileName;
  List<PlatformFile> _paths;

  String text;

  void _openFileExplorer() async {
    pageImage = null;
    text = "Processing...";
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        withReadStream: true,
        allowMultiple: true,
        allowCompression: true,
        onFileLoading: (FilePickerStatus status) => text = "Processing...",
      ))
          .files;

      _paths == null
          ? text = "Drop your file or click here"
          : text = "Processing...";
    } on PlatformException catch (e) {
      // print("Unsupported operation" + e.toString());
    } catch (ex) {
      // print("ex:$ex");
    }

    // int i = 5;
    int i = 11;
    if (!mounted) return print("");
    if (_paths?.isEmpty ?? true) {
      validation = 0;
    } else {
      Dailog_toast().showAlertDialog(context);
      validation = _paths.length + hashList.length;
    }

    validation >= i
        ? ab()
        : setState(() {
            for (int i = 0; i < _paths?.length; i++) {
              _fileName =
                  _paths != null ? _paths.map((e) => e.name).toString() : '...';

              final path = _paths.map((e) => e.path).toList()[i].toString();
              var file = File(path);
              int sizeInBytes = file.lengthSync();
              double sizeInMb = sizeInBytes / (1024 * 1024);
              filename = _paths.map((e) => e.name).toList()[i].toString();
              filenameList.contains(filename)
                  ? print("")
                  : filenameList.add(filename);
              var bytes = File(path).readAsBytesSync();
              final uri = lookupMimeType(path);
              String base64Image = "data:$uri;base64," + base64Encode(bytes);
              uri == null
                  ? Dailog_toast()
                      .showError(context, "This file format is not supported")
                  : print(""); // hash(base64Image, filename, sizeInMb);
              hash(base64Image, filename, sizeInMb);
            }
            Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code

              setState(() {
                updateAlbum("none");
              });
            });
          });
  }

  ab() {
    setState(() {
      text = "Drop your file or click here";
      Dailog_toast().showError(context, "Maximum 10 file allowed to validate");
      Navigator.pop(context);
    });
  }

  hash(var id, filename, sizeInMb) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var watermark = preferences.getString('watermark');

    var bytes = utf8.encode(id); // data being hashed
    // ignore: unused_local_variable
    var digest = sha1.convert(bytes);
    hash1 = sha256.convert(bytes);
    // text = "Drop your file or click here";
    setState(() {
      text = "Drop your file or click here";
      var a = hash1;
      hashList.contains(a.toString())
          ? Dailog_toast().showError(context, "Duplicate file")
          : hashList.add(a.toString());
    });
  }

  Future updateAlbum(text) async {
    selectedUserss.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var hashbody = {"hash": hashList};

    var url = Uri.https(
        '${Backend.baseurl}', '${Backend.multihash}', {'q': '{https}'});
    // ignore: unused_local_variable
    final http.Response response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: token
            },
            body: jsonEncode(hashbody))
        // ignore: missing_return
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          text == "none" ? Navigator.pop(context) : print("");
          text = "Drop your file or click here";
          dataaa = jsonDecode(response.body);
          dataList = dataaa['data'];
          // val1 = false;
          List ids = [false];
          setState(() {
            dataList.forEach((u) {
              u['stamped'] == ids[0]
                  ? selectedUserss.contains(u.toString())
                      ? {Dailog_toast().showError(context, "Duplicate file")}
                      : selectedUserss.add(u.toString())
                  : printStatus("message:${u['stamped']}");
            });
          });
        });
      } else {
        Navigator.pop(context);
        text = "Drop your file or click here";
      }
    });
  }

// Showcase stamped and not stamped file in table
  _dataTable() {
    return DataTable(
      headingRowColor:
          MaterialStateColor.resolveWith((states) => Colors.grey[50]),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Filename'.toUpperCase(),
            style: const TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.black),
          ),
        ),
        DataColumn(
          label: Text(
            'Status'.toUpperCase(),
            style: const TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.black),
          ),
        ),
        DataColumn(
          label: Text(
            'Actions'.toUpperCase(),
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ],
      rows: List.generate(dataList.length, (index) {
        return DataRow(cells: <DataCell>[
          DataCell(
            Text(
              filenameList[index],
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            //  ),
          ),

          DataCell(Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: dataaa['data'][index]["stamped"] == true
                    ? Colors.green
                    : Colors.red),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              child: Text(
                dataaa['data'][index]["stamped"] == true
                    ? "STAMPED"
                    : "NOT STAMPED",
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          )),
          // ignore: unnecessary_string_interpolations

          DataCell(
            //  val1 == true
            Index.contains(index)
                ? Container(
                    //color: Colors.blue,
                    child: const Text("Processing..."),
                  )
                : Wrap(
                    children: [
                      dataaa['data'][index]["stamped"] == true
                          ? Tooltip(
                              message: "View",
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                child: const Icon(
                                  Icons.visibility_outlined,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StampedDocument(
                                            id: dataaa['data'][index][
                                                "hash"] // "data[index]["hash"],"
                                            ),
                                      ));
                                },
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        width:
                            dataaa['data'][index]["stamped"] == false ? 0 : 10,
                      ),
                      dataaa['data'][index]["stamped"] == false
                          ? Tooltip(
                              message: "Add Stamp",
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                child: Image.asset(
                                  "assets/Images/stamp_black.png",
                                  filterQuality: FilterQuality.none,
                                  height: 20,
                                ), //const Icon(Icons.catching_pokemon),
                                onTap: () {
                                  if (token != null && token != '') {
                                    setState(() {
                                      Index.add(index);
                                    });

                                    // updateAlbum1(index);
                                  } else {
                                    Dailog_toast().showError(context,
                                        "You need to login to access this features");
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        width:
                            dataaa['data'][index]["stamped"] == false ? 10 : 0,
                      ),
                      dataaa['data'][index]["stamped"] == false
                          ? Tooltip(
                              message: "Add Stamp With Metadata",
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                child: Image.asset(
                                  "assets/Images/table_black.png",
                                  filterQuality: FilterQuality.none,
                                  height: 20,
                                ),
                                //  const Icon(
                                //   Icons.margin_outlined,
                                // ),
                                onTap: () {
                                  if (token != null && token != '') {
                                    // showWatermark(
                                    //   context,
                                    //   filenameList[index],
                                    //   hashList[index],
                                    //   1,
                                    // );
                                  } else {
                                    Dailog_toast().showError(context,
                                        "You need to login to access this features");
                                  }
                                  // showWatermark1(context);
                                },
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                          width: dataaa['data'][index]["stamped"] == false
                              ? 10
                              : 0),
                      Tooltip(
                        message: "Remove",
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Icon(
                              Icons.clear,
                            ),
                            // Image.asset(
                            //   "assets/Images/cancel.png",
                            //   filterQuality: FilterQuality.medium,
                            //   height: 15,
                            //   color: Colors.black,
                            // ),
                          ),
                          onTap: () {
                            setState(() {
                              filenameList.removeAt(index);
                              dataList.removeAt(index);
                              hashList.removeAt(index);
                              selectedUserss.contains(dataaa['data'][index])
                                  ? selectedUserss
                                      .remove({dataaa['data'][index]})
                                  : print("");
                            });
                          },
                        ),
                      )
                    ],
                  ),
          )
        ]);
      }),
    );
  }

  void _showAlert(
    BuildContext context,
  ) {
    showDialog<String>(
        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            //   builder: (BuildContext buildContext, Animation animation,
            //   Animation secondaryAnimation) {
            SizedBox(
              height: 400,
              width: 300,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                // type: MaterialType.transparency,
                body: Padding(
                  padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey, //Color(0xffff073D83),
                                width: 1),
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(10)),
                            color: Colors.white),
                        width: 300, //MediaQuery.of(context).size.width / 4,
                        height: 375, //MediaQuery.of(context).size.height / 3,
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 0.5,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: Color(
                                          0xFFFFe8f0fe), // Colors.blue[100],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text:
                                            'This account is managed by edeXa .',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: ' Learn more',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF073D83),
                                                // Color(0xffe46b10),
                                                fontSize: 12),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launch("https://edexa.com/en/"
//'https://edexa.com/en/terms-and-conditions/'
                                                    );
                                              },
                                          ),
                                        ]),
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundImage: NetworkImage(
                                    profilePicture,
                                  ), //AssetImage('assets/Images/images.jpg'),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                                child: Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(child: Text(email)),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width / 0.8,
                                child: ElevatedButton(
                                  onPressed: () {
                                    launch(
                                        'https://accounts.io-world.com/profile');
                                  },
                                  child: const Text(
                                      "       Manage your edeXa account      "),
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(2),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Color(0xffff073D83))),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width / 0.8,
                                child: OutlinedButton(
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Dialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          child: SizedBox(
                                            width: 50,
                                            child: Wrap(
                                              children: [
                                                Wrap(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              color: Color(
                                                                  0xffff073D83), // Colors.red,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons
                                                              .error_outline_sharp,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                    //  const Divider(),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: Wrap(
                                                    children: const [
                                                      Center(
                                                          child: Text(
                                                              'Are you sure ?')),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      OutlinedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: const Text(
                                                              'cancel')),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          prefs.remove('token');
                                                          prefs.remove(
                                                              'secretId');
                                                          prefs.remove(
                                                              'secretId');
                                                          prefs.remove(
                                                              "viewType");
                                                          //  Navigator.pushNamed(context, "/");
                                                          Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Main() //  SearchPage(), //edexaLogin()
                                                                      //LoginPage(),
                                                                      ));
                                                        },
                                                        child: const Text(
                                                          'Logout',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(("Logout"))),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            const Divider(),

                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width / 0.8,
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop();
                                    },
                                    child: Text(("Cancel"))),
                              ),
                            ),

                            const Divider(),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'Privacy Policy ',
                                  style: //GoogleFonts.portLligatSans(
                                      const TextStyle(
                                          fontSize: 12, color: Colors.grey
                                          //Color(0xffe46b10),
                                          ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(
                                          'https://edexa.com/en/privacy-policy/');
                                    },
                                  children: [
                                    const TextSpan(
                                      text: ' - ',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w700,
                                          //color: Color(0xFF073D83),
                                          fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          // color: Color(0xFF073D83),
                                          // Color(0xffe46b10),
                                          fontSize: 12),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch(
                                              'https://edexa.com/en/terms-and-conditions/');
                                        },
                                    ),
                                  ]),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ));
  }
}

// ignore_for_file: non_constant_identifier_names

