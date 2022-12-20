// @dart=2.9
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bStamp/bottom_Navigation/appbar.dart';
import 'package:crypto/crypto.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'backend.dart';
import 'package:http_parser/http_parser.dart';
import 'bottom_Navigation/dialog_toast.dart';
import 'bottom_Navigation/stampeddocument.dart';
import 'edexa_login.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    //  Navigator.of(context).maybePop();
    checkIsLogin();
    // _getStampList();
    setpath();
  }

  var color1 = Colors.black, color = Colors.black;
  final ItemScrollController _scrollController = ItemScrollController();
  // ignore: prefer_typing_uninitialized_variables
  var dataaa, dirpaths;
  List selectedUserss = [];
  List<String> data1;
  var text = "Drop your file or click here";
  bool val = false;
  bool val1 = false;
  bool a = false;
  // List arr = [];
  List<String> label = [];
  List desc = [];
  List Index = [];
  int i = 0;
  List a1 = [];
  int count = 0;
  var ct;
  TextEditingController temptext;
  List<List<TextEditingController>> labelController = [];
  List<List<TextEditingController>> descriptionController = [];
  TextEditingController lab1 = TextEditingController();
  TextEditingController lab2 = TextEditingController();
  TextEditingController desc1 = TextEditingController();
  TextEditingController desc2 = TextEditingController();
  bool ignoreval2 = false;
  String ignorevalue;
  setpath() async {
    dirpaths = null;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dirpaths = preferences.getString("Dir");
  }

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
      preferences.setString("align", jsonResponse['data']['align'].toString());
      _getUserInfo();
      setState(() {});
    } else {
      var jsonResponse = convert.jsonDecode(response.body);

      // ignore: avoid_print

    }
  }

  List name1 = [];
  final searchbar = TextEditingController();
  var focusNode = FocusNode();
  var token, email, name, username, profilePicture, align;
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
      align = preferences.getString(
        'align',
      );
      // print(profilePicture);
    });
  }

  Offset offset;
  List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>()];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // fontFamily: 'Lato',
          textTheme: GoogleFonts.latoTextTheme(
            // headline1: GoogleFonts.lato(textStyle: textTheme.headline1),
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: true,
            body: Container(
                color: Colors.white,
                height: MediaQuery.of(context).copyWith().size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 8,
                      ),

                      Center(
                        child: SizedBox(
                          // height: 100,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: SizedBox(
                              // color: Colors.white,
                              child: Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 0),
                            child: TextFormField(
                              onFieldSubmitted: (event) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StampedDocument(
                                        id: searchbar.text.trim(),
                                      ),
                                    ));
                              },
                              style: const TextStyle(fontSize: 25),
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
                            //   )
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
                            onDragEntered: (_) {
                              // text = "Processing..";
                            },
                            onDragUpdated: (_) {
                              //  text = "Processing..";
                            },
                            onDragDone: (detail) {
                              Dailog_toast().showAlertDialog(context);
                              int o = 11;
                              validation =
                                  detail.files.length + hashList.length;
                              validation >= o
                                  ? _showValidatMessage()
                                  : {
                                      for (int i = 0;
                                          i < detail.files.length;
                                          i++)
                                        {
                                          setState(() {
                                            filename = detail.files[i].path
                                                .split('/')
                                                .last
                                                .replaceAll("%20", " ");
                                            filenameList.add(detail
                                                .files[i].path
                                                .split('/')
                                                .last
                                                .replaceAll("%20", " "));

                                            // print(filenameList[i]);

                                            String c = detail.files[i].path;
                                            //   String d = c.replaceFirst("/", "");
                                            String d = c.replaceAll("%20", " ");
                                            final bytes = File(
                                                //"file:///home/edexa/Documents/Untitled document (8).pdf")
                                                // "${c.replaceAll("%20", " ")}"
                                                d).readAsBytesSync();

                                            uri = lookupMimeType(c);
                                            //  text = "Processing..";
                                            var file =
                                                File(d.replaceAll("%20", " "));
                                            int sizeInBytes = file.lengthSync();
                                            double sizeInMb =
                                                sizeInBytes / (1024 * 1024);

                                            String base64Image =
                                                "data:$uri;base64," +
                                                    base64Encode(bytes);

                                            hash(base64Image, filename,
                                                sizeInMb);
                                            // _list.addAll(detail.urls);
                                          }),
                                        },
                                      updateAlbum4("ok", detail)
                                    };
                            },
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  // arr.clear();
                                  //  _openfile();
                                  _openFileExplorer();
                                });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.width / 11,
                                width: MediaQuery.of(context).size.width / 1.5,
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
                                            text,
                                            //  "$filename",
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
                              width: MediaQuery.of(context).size.width / 1.5,
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

                                  SizedBox(width: 10),
// elctronic signature button
                                  signaturefile.length > 1
                                      ? ElevatedButton.icon(
                                          style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                Size.fromHeight(10),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffff073d83)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.only(
                                                          left: 10,
                                                          right: 10))),
                                          onPressed: () {
                                            if (token != null && token != '') {
                                              labelController.clear();
                                              descriptionController.clear();

                                              for (int i = 0;
                                                  i < selectedUserss.length;
                                                  i++) {
                                                labelController.add([
                                                  TextEditingController(
                                                      text: "filename"),
                                                  TextEditingController(
                                                      text: "hash")
                                                ]);
                                                //  String file = selectedUserss[i];
                                                descriptionController.add([
                                                  TextEditingController(
                                                      text: selectfile[i]),
                                                  TextEditingController(
                                                      text: selectHash[i])
                                                ]);
                                              }
                                              Dailog_toast()
                                                  .showAlertDialog(context);
                                              getHttp1("withPdf");
                                            } else {
                                              Dailog_toast().showError(context,
                                                  "You need to login to access this features");
                                            }
                                          },
                                          icon: Image.asset(
                                            "assets/Images/electronic.png",
                                            //"assets/Images/stamp_white.png",
                                            height: 20,
                                          ), //const Icon(Icons.ac_unit),
                                          label: const Text(
                                              "Add Electronic Signature"))
                                      : SizedBox(),
                                  SizedBox(width: 10),
//Add Electronic signature with metadata
                                  signaturefile.length > 1
                                      ? ElevatedButton.icon(
                                          style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                Size.fromHeight(10),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffff073d83)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.only(
                                                          left: 10,
                                                          right: 10))),
                                          onPressed: () {
                                            if (token != null && token != '') {
                                              showWatermark(
                                                  context,
                                                  filename,
                                                  hash,
                                                  signaturefile.length,
                                                  "Signature",
                                                  "Stamp All");
                                            } else {
                                              Dailog_toast().showError(context,
                                                  "You need to login to access this features");
                                            }
                                          },
                                          icon: Image.asset(
                                            "assets/Images/signMetadata.png",
                                            height: 20,
                                          ), //const Icon(Icons.ac_unit),
                                          label: const Text(
                                              "Add Electronic Signature with MetaData"))
                                      : SizedBox(),
                                  SizedBox(width: 10),

                                  selectedUserss.length > 1
                                      ? ElevatedButton.icon(
                                          style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                Size.fromHeight(10),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffff073d83)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.only(
                                                          left: 10,
                                                          right: 10))),
                                          onPressed: () {
                                            if (token != null && token != '') {
                                              labelController.clear();
                                              descriptionController.clear();

                                              for (int i = 0;
                                                  i < selectedUserss.length;
                                                  i++) {
                                                labelController.add([
                                                  TextEditingController(
                                                      text: "filename"),
                                                  TextEditingController(
                                                      text: "hash")
                                                ]);
                                                //  String file = selectedUserss[i];
                                                descriptionController.add([
                                                  TextEditingController(
                                                      text: selectfile[i]),
                                                  TextEditingController(
                                                      text: selectHash[i])
                                                ]);
                                              }
                                              Dailog_toast()
                                                  .showAlertDialog(context);
                                              getHttp1("hjhj");
                                            } else {
                                              Dailog_toast().showError(context,
                                                  "You need to login to access this features");
                                            }
                                          },
                                          icon: Image.asset(
                                            "assets/Images/stamp_white.png",
                                            height: 20,
                                          ), //const Icon(Icons.ac_unit),
                                          label: const Text("Stamp All"))
                                      : SizedBox(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  selectedUserss.length > 1
                                      ? ElevatedButton.icon(
                                          style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                const Size.fromHeight(10),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(
                                                          0xffff073d83)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10))),
                                          onPressed: () {
                                            if (token != null && token != '') {
                                              showWatermark(
                                                  context,
                                                  filename,
                                                  hash,
                                                  selectedUserss.length,
                                                  "ui",
                                                  "Stamp All");
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
                                              "Stamp All with MetaData"))
                                      : SizedBox(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton.icon(
                                      style: ButtonStyle(
                                          fixedSize: MaterialStateProperty.all(
                                            Size.fromHeight(5),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xffff073d83)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.all(5))),
                                      onPressed: () {
                                        setState(() {
                                          //dataaa.clear();
                                          signaturefile.clear();
                                          signaturehash.clear();
                                          dataaa = null;
                                          hashList.clear();
                                          selectedUserss.clear();
                                          filenameList.clear();
                                          selectHash.clear();
                                          selectfile.clear();
                                          pathhhhhh.clear();

                                          // dataList.remove(dataList.length);
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                      label: const Text("Clear All")),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      dataList.length == 0 || dataaa == null
                          ? Container()
                          : SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: _dataTable(),
                            ),
                      const SizedBox(
                        height: 15,
                      ),

                      dataList.length == 0 || dataaa == null
                          ? const SizedBox()
                          : Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Displaying a total of  ${hashList.length}  ${hashList.length == 1 ? "stamp" : "stamps"} ",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.w900,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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

  // ignore: prefer_typing_uninitialized_variables
  var bytes1;
  // ignore: prefer_typing_uninitialized_variables
  var hash1;
  // ignore: unused_field
  String _fileName;
  List<PlatformFile> _paths = [];
  List<PlatformFile> _paths1 = [];
  List<dynamic> hashList = [];
  List<dynamic> dataList = [];
  var pageImage, pageImagee;
  String filename;
  List<dynamic> filenameList = [];
  int validation = 0;
  List selectfile = [];
  List signaturefile = [];
  List signaturehash = [];

  List selectHash = [];
  var uri;

  void _openFileExplorer() async {
    pageImage = null;
    text = "Processing...";

    try {
      _paths = (await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.any,
        withReadStream: true,
        allowMultiple: true,
        allowCompression: true,
        onFileLoading: (FilePickerStatus status) => text = "Processing...",
      ))
          ?.files;
      // _paths != null ? print(_paths.length) : _openFileExplorer();
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
        ? _showValidatMessage()
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
              uri = lookupMimeType(path);
              String base64Image = "data:$uri;base64," + base64Encode(bytes);
              uri == null
                  ? {
                      showError(context,
                          "This ${uri == null ? "" : uri} file format is not supported"),
                      _paths.remove(i),
                      filenameList.remove(filename)
                    }
                  : hash(base64Image, filename, sizeInMb);
              // hash(base64Image, filename, sizeInMb);
            }
            Future.delayed(const Duration(seconds: 2), () {
// Here you can write your code

              setState(() {
                updateAlbum("none", _paths);
              });
            });
          });
  }

  _showValidatMessage() {
    setState(() {
      text = "Drop your file or click here";
      showError(context, "Maximum 10 file allowed to validate");

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
          ? {
              showError(context, "Your file already exist"),
            }
          : uri != null
              ? hashList.add(a.toString())
              : print("");
    });
  }

  var ooo;
  List pathhhhhh = [];
  Future updateAlbum4(String text1, p) async {
    // selectedUserss.clear();
    // _paths1.clear();
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
          Navigator.of(context).maybePop();

          text = "Drop your file or click here";
          dataaa = jsonDecode(response.body);
          setState(() {
            dataList = dataaa['data'];
          });

          val1 = false;
          List ids = [false];
          //  setState(() {
          selectedUserss.clear();
          selectfile.clear();
          signaturefile.clear();
          signaturehash.clear();
          selectHash.clear();
          for (int k = 0; k < dataList.length; k++) {
            Map u = dataList[k];
            u['stamped'] == ids[0]
                ? selectedUserss.contains(u.toString())
                    ? {}
                    : selectedUserss.add(u.toString())
                : printStatus("message:${u['stamped']}");

            ///////////////////////////////////////////////////
            u['stamped'] == ids[0]
                ? selectHash.contains(hashList[k])
                    ? {}
                    : selectHash.add(hashList[k])
                : printStatus("message:${hashList[k]}");
            //////////////////////////////////////////////
            u['stamped'] == ids[0]
                ? selectfile.contains(filenameList[k])
                    ? {}
                    : {
                        selectfile.add(filenameList[k]),
                        filenameList[k].contains(".pdf")
                            ? {
                                signaturefile.add(filenameList[k]),
                                signaturehash.add(hashList[k])
                              }
                            : print(""),

                        for (int l = 0; l < p.urls.length; l++)
                          {
                            ooo = p.urls[l].path
                                .split('/')
                                .last
                                .replaceAll("%20", " "),
                            // : "f",

                            ooo.contains(filenameList[k]) &&
                                    ooo.contains(".pdf")
                                ? _paths1.contains(p.urls[l].path)
                                    ? {}
                                    : {
                                        pathhhhhh.add(p.urls[l].path),
                                        pathhhhhh = pathhhhhh.toSet().toList()
                                      } //_paths1.add(p[l])
                                : print(""),
                            //_paths.add(_paths[l]);
                          }

                        //  Index.add(k),
                        // ignore: iterable_contains_unrelated_type
                      }
                : printStatus("message:${u['stamped']}");
          }
          // dataList.forEach((u) {

          // });
          //  });

          text1 == "none"
              ? print("")
              : Future.delayed(const Duration(seconds: 4), () {
                  Navigator.of(context).maybePop();
                });
        });
      } else {
        Navigator.pop(context);
        text = "Drop your file or click here";
      }
    });
  }

//Multifile Drag & Drop API
  Future updateAlbum(String text1, p) async {
    // selectedUserss.clear();
    // _paths1.clear();
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
          Navigator.of(context).maybePop();

          text = "Drop your file or click here";
          dataaa = jsonDecode(response.body);
          setState(() {
            dataList = dataaa['data'];
          });

          val1 = false;
          List ids = [false];
          signaturefile.clear();
          signaturehash.clear();
          //  setState(() {
          selectedUserss.clear();
          selectfile.clear();
          selectHash.clear();
          for (int k = 0; k < dataList.length; k++) {
            Map u = dataList[k];
            u['stamped'] == ids[0]
                ? selectedUserss.contains(u.toString())
                    ? {}
                    : selectedUserss.add(u.toString())
                : printStatus("message:${u['stamped']}");

            ///////////////////////////////////////////////////
            u['stamped'] == ids[0]
                ? selectHash.contains(hashList[k])
                    ? {}
                    : selectHash.add(hashList[k])
                : printStatus("message:${hashList[k]}");
            //////////////////////////////////////////////
            u['stamped'] == ids[0]
                ? selectfile.contains(filenameList[k])
                    ? {}
                    : {
                        selectfile.add(filenameList[k]),
                        filenameList[k].contains(".pdf")
                            ? {
                                signaturefile.add(filenameList[k]),
                                signaturehash.add(hashList[k])
                              }
                            : print(""),
                        for (int l = 0; l < _paths.length; l++)
                          {
                            ooo = _paths
                                .map((e) => e.name)
                                .toList()[l]
                                .toString(),
                            // : "f",

                            ooo.contains(filenameList[k]) &&
                                    ooo.contains(".pdf")
                                ? _paths1.contains(_paths[l])
                                    ? {}
                                    : {
                                        pathhhhhh.add(_paths[l].path),
                                        pathhhhhh = pathhhhhh.toSet().toList(),
                                        _paths1.add(_paths[l]),
                                      }
                                : print("") //_paths.add(_paths[l]);
                          }

                        //  Index.add(k),
                        // ignore: iterable_contains_unrelated_type
                      }
                : printStatus("message:${u['stamped']}");
          }
          // dataList.forEach((u) {

          // });
          //  });

          text1 == "none"
              ? print("")
              : Future.delayed(const Duration(seconds: 4), () {
                  Navigator.of(context).maybePop();
                });
        });
      } else {
        Navigator.pop(context);
        text = "Drop your file or click here";
        var errormsg = json.decode(response.body);
        Dailog_toast().showError(context, errormsg["message"]);
      }
    });
  }

// Stamped single or multiple file
  Future updateAlbum1(i, List a) async {
    setState(() {
      val1 = true;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var url = Uri.https(
        '${Backend.baseurl}', '${Backend.createstamp}', {'q': '{https}'});

    Map<String, dynamic> metaData = new Map<String, dynamic>();
    metaData = {"type": "3"};

    for (int j = 0; j < a.length; j++) {
      //  metaParams = metaParams + '"${label[i]}"' + ":" + '"${desc[i]}",';
      metaData.addAll(
          {labelController[i][j].text: descriptionController[i][j].text});
    }

    final http.Response response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: token
            },
            body: jsonEncode(metaData))
        // ignore: missing_return
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          Navigator.of(context);
          Index.clear();
          val1 = false;
          Dailog_toast().showSuccess(context, "Document stamped successfully");
          // _dialog(1, "Document stamped successfully");
          filename = null;
          // ignore: unused_local_variable
          var myData = json.decode(response.body);

          var ff = dataaa['data'][i]["stamped"];

          updateAlbum("ok", "");
          val1 = false;

          final tile = dataaa.firstWhere((item) => dataaa['data'][i] == '$i',
              orElse: () => null);
          if (tile != null)
            setState(() => dataaa['data'][i]["stamped"] = 'true');
        });
      } else {
        setState(() {
          Navigator.of(context).maybePop();
          // Navigator.of(context);
          Index.clear();
          val1 = false;
        });
        var errormsg = json.decode(response.body);
        Dailog_toast().showError(context, errormsg["message"]);
      }
    });
  }

//metadata popup
  var _currentSelectedValue = "Top";
  _value1(Controller, Controller1, index, section, filename, hash, mark) {
    // for (i = 0; i < arr.length; i++) {

    if (labelController[section].length == 2) {
      val = false;
      label.add(
        "filename",
      );
      label.add("hash");
      mark == "Signature" ? label.add("Watermark Position") : print("");
      desc.add(filename);
      desc.add(hash);
      mark == "Signature" ? desc.add("$align") : print("");
      labelController[section][index].text = label[index];
      descriptionController[section][index].text = desc[index];
    } else {
      if (mark == "Signature" ? index < 3 : index < 2) {
        //  val = false;
        label.add(
          "filename",
        );
        label.add("hash");
        mark == "Signature" ? label.add("Watermark Position") : print("");
        desc.add(filename);
        desc.add(hash);
        mark == "Signature" ? desc.add("$_currentSelectedValue") : print("");
        labelController[section][index].text = label[index];
        descriptionController[section][index].text = desc[index];
      } else {
        val = true;
      }
    }
  }

// Showcase stamped and not stamped file in table
  _dataTable() {
    return DataTable(
      columnSpacing: 100, // MediaQuery.of(context).size.width / 7, // 300,
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
            // Flexible(
            //   flex: 1,
            //   fit: FlexFit.tight,
            //   child:
            Container(
              width: 340,
              padding: const EdgeInsets.only(right: 13.0),
              child: Tooltip(
                preferBelow: false,
                textStyle: const TextStyle(
                    fontSize: 12,
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey),
                message: filenameList[index],
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(
                  filenameList[index],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ),
            //),
            // SizedBox(
            //   width: 400,
            //   child: Card(
            //     // fit: BoxFit.contain,
            //     child: Text(
            //       " filenameList[index]h   fgtj  jjjj    jjjj                                         jjjj  jjjjjjj   jjjjjj                       jjjjjj x   jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj     x  jjj      x  jjcfvbgfcdvgfvgdvgxxxj",
            //       overflow: TextOverflow.fade,
            //       // softWrap: true,
            //       style: const TextStyle(
            //           fontSize: 15,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.grey),
            //     ),
            //   ),
            // ),

            //  ),Color.fromARGB(
            //                                                232, 53, 136, 245)
          ),

          DataCell(Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: dataaa['data'][index]["stamped"] == true
                    ? dataaa['data'][index]["stamped"] ==
                            dataaa['data'][index]["isEsign"]
                        ? Color.fromARGB(232, 53, 136, 245)
                        : Colors.green
                    : Colors.red),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              child: Text(
                dataaa['data'][index]["stamped"] == true
                    ? dataaa['data'][index]["stamped"] ==
                            dataaa['data'][index]["isEsign"]
                        ? "Signed & Stamped".toUpperCase()
                        : "STAMPED"
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
                      dataaa['data'][index]["stamped"] == false &&
                              filenameList[index].contains(".pdf")
                          ? Tooltip(
                              message: "Electronic signature",
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                child: Image.asset(
                                  "assets/Images/electronic.png",
                                  color: Colors.black,
                                  // "assets/Images/stamp_black.png",
                                  filterQuality: FilterQuality.none,
                                  height: 20,
                                ), //const Icon(Icons.catching_pokemon),
                                onTap: () {
                                  if (token != null && token != '') {
                                    labelController.clear();
                                    descriptionController.clear();

                                    labelController.add([
                                      TextEditingController(text: "filename"),
                                      TextEditingController(text: "hash")
                                    ]);

                                    descriptionController.add([
                                      TextEditingController(
                                          text: filenameList[index]),
                                      TextEditingController(
                                          text: hashList[index])
                                    ]);
                                    Dailog_toast().showAlertDialog(context);
                                    getHttp();
                                  } else {
                                    Dailog_toast().showError(context,
                                        "You need to login to access this features");
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        width: dataaa['data'][index]["stamped"] == false &&
                                filenameList[index].contains(".pdf")
                            ? 10
                            : 0,
                      ),
                      dataaa['data'][index]["stamped"] == false &&
                              filenameList[index].contains(".pdf")
                          ? Tooltip(
                              message: "Add Electronic Signature With Metadata",
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                child: Image.asset(
                                  "assets/Images/signMetadata.png",
                                  color: Colors.black,
                                  //"assets/Images/table_black.png",
                                  filterQuality: FilterQuality.none,
                                  height: 20,
                                ),
                                //  const Icon(
                                //   Icons.margin_outlined,
                                // ),
                                onTap: () {
                                  if (token != null && token != '') {
                                    showWatermark(
                                        context,
                                        filenameList[index],
                                        hashList[index],
                                        1,
                                        "Signature",
                                        "Stamp");
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
                          width: dataaa['data'][index]["stamped"] == false &&
                                  filenameList[index].contains(".pdf")
                              ? 10
                              : 0),
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
                                    labelController.clear();
                                    descriptionController.clear();

                                    labelController.add([
                                      TextEditingController(text: "filename"),
                                      TextEditingController(text: "hash")
                                    ]);

                                    // descriptionController.add([
                                    //   TextEditingController(
                                    //       text: selectfile[index]),
                                    //   TextEditingController(
                                    //       text: selectHash[index])
                                    // ]);
                                    descriptionController.add([
                                      TextEditingController(
                                          text: filenameList[index]),
                                      TextEditingController(
                                          text: hashList[index])
                                    ]);
                                    Dailog_toast().showAlertDialog(context);
                                    //  updateAlbum1(index, labelController[index]);
                                    getHttp1("h");
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
                                    showWatermark(context, filenameList[index],
                                        hashList[index], 1, "ui", "Stamp");
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
                        width:
                            dataaa['data'][index]["stamped"] == false ? 10 : 0,
                      ),
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
                              var hh = dataList[index].toString();
                              var t = filenameList[index];
                              var w = hashList[index];
                              signaturefile.contains(t)
                                  ? {
                                      signaturefile.remove(t),
                                      signaturehash.remove(w)
                                    }
                                  : print("");
                              // var r = _paths[index]==null?index:_paths[index];
                              // pathhhhhh[index].contains(t)
                              //     ? pathhhhhh.removeAt(index)
                              //     : print("");
                              filenameList.removeAt(index);
                              //   _paths1.remove(r);

                              hashList.removeAt(index);
                              selectedUserss.contains(hh)
                                  ? {
                                      selectedUserss.remove(hh),
                                      selectfile.remove(t),
                                      selectHash.remove(w),
                                    }
                                  : print("");

                              dataList.removeAt(index);
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

// showcase profile data popup
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
                                      color: const Color(
                                          0xffffe8f0fe), // 0xFFFFe8f0fe Colors.blue[100],
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
                                        'https://accounts.edexa.com/profile');
                                  },
                                  child: const Text(
                                      "       Manage your edeXa account      "),
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(2),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Color(0xffff073d83))),
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
                                                                  0xffff073d83), // Colors.red,
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
                                          // fontWeight: FontWeight.w900,
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

  void showError(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => _showAlertt(context, message, const Color(0xFFFDE2E1),
        Icons.error_outline, Colors.red, shouldDismiss));
  }

  void _showAlertt(BuildContext context, String message, Color color,
      IconData icon, Color iconColor, bool shouldDismiss) {
    showGeneralDialog(
        barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          if (shouldDismiss) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context, rootNavigator: true).pop();
            });
          }
          return Material(
            type: MaterialType.transparency,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 100, right: 50, left: 50),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: iconColor, width: 1),
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                              bottom: Radius.circular(10)),
                          color: Colors.white),
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.height / 10,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            icon,
                            size: 30,
                            color: iconColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          );
        });
  }

  hash2(var id, filename) async {
    i = 2;

    var bytes = utf8.encode(id); // data being hashed
    // ignore: unused_local_variable
    var digest = sha1.convert(bytes);
    hash1 = sha256.convert(bytes);
    setState(() {
      var a = hash1;
      label.add("filename");
      desc.add(filename);
      label.add("hash");
      desc.add("$a");
      // add();
    });
  }

  //multifile Stamp
  void showWatermark(
      BuildContext context, filename, hash, indexx, mark, Stamplabel) {
    // i = 2;
    a1.clear();
    labelController.clear();
    descriptionController.clear();
    ignoreval2 = false;
    for (int i = 0; i < indexx; i++) {
      mark == "Signature" ? a1.add(4) : a1.add(3);

      List<TextEditingController> lst = [];
      lst.add(TextEditingController());
      lst.add(TextEditingController());
      lst.add(TextEditingController());
      mark == "Signature" ? lst.add(TextEditingController()) : print("");
      List<TextEditingController> lst1 = [];
      lst1.add(TextEditingController());
      lst1.add(TextEditingController());
      lst1.add(TextEditingController());
      mark == "Signature" ? lst1.add(TextEditingController()) : print("");
      //lst1.add(TextEditingController());

      labelController.add(lst);
      descriptionController.add(lst1);
    }

    showDialog(
        useRootNavigator: false,
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
              key: UniqueKey(),
              builder: (context, setState) {
                return AlertDialog(actions: <Widget>[
                  Row(
                    children: [
                      const Text(
                        "Stamp MetaData",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      mark == "Signature"
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(232, 53, 136, 245)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 5.0,
                                    bottom: 5.0),
                                child: Text(
                                  "Electronic Signature".toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ),
                            )
                          : SizedBox(),
                      const Spacer(),
                      IconButton(
                          hoverColor: Colors.transparent,
                          onPressed: () {
                            ignoreval2 = false;
                            Navigator.of(
                              context,
                            ).pop();
                          },
                          icon: const Icon(Icons.cancel_outlined))
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                      width: MediaQuery.of(context).size.width, // 1.3,
                      height: 300,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ListView.separated(
                            itemCount: indexx, // selectedUserss.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              label.clear();
                              desc.clear();

                              count = a1[index];

                              int ggg = index;

                              indexx > 1
                                  ? {
                                      filename = mark == "Signature"
                                          ? signaturefile[index]
                                          : selectfile[index],
                                      hash = mark == "Signature"
                                          ? signaturehash[index]
                                          : selectHash[index]
                                    }
                                  : print("");
                              return Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        indexx == 1
                                            ? filename
                                            : mark == "Signature"
                                                ? signaturefile[index]
                                                : selectfile[index],
                                        //"${filenameList[index]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            // i++;
                                            var ct = a1[index];
                                            ct += 1;
                                            a1[index] = ct;

                                            labelController[ggg]
                                                .add(TextEditingController());
                                            descriptionController[ggg]
                                                .add(TextEditingController());
                                            ignoreButton();
                                          });
                                        },
                                        child: MouseRegion(
                                            onEnter: (e) {
                                              setState(() {
                                                color = Color(0xffff005397);
                                              });
                                            },
                                            onExit: (e) {
                                              setState(() {
                                                color = Color(0xffff073d83);
                                              });
                                            },
                                            child: mark == "Signature"
                                                ? Text(
                                                    count != 8
                                                        ? "Add Metadata"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        // ignore: use_full_hex_values_for_flutter_colors
                                                        color: filename == null
                                                            ? Colors.grey
                                                            : color //Color(0xffff005397)
                                                        ))
                                                : Text(
                                                    count != 7
                                                        ? "Add Metadata"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        // ignore: use_full_hex_values_for_flutter_colors
                                                        color: filename == null
                                                            ? Colors.grey
                                                            : color //Color(0xffff005397)
                                                        ))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1.0, right: 1.0),
                                    child: Wrap(
                                      children: [
                                        Container(
                                            height: //arr.isEmpty
                                                count == 0
                                                    ? 50
                                                    : a1.length == 2
                                                        ? 160
                                                        : 210,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: labelController[index]
                                                    .isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      "Not added any metatdata, click to add metadata",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  )
                                                :
                                                //  Scrollbar(
                                                //     showTrackOnHover: true,
                                                //     // isAlwaysShown: true,
                                                //     hoverThickness: 10,
                                                //     interactive: true,
                                                //     child: ScrollablePositionedList
                                                //         .builder(
                                                //             initialScrollIndex: 0,
                                                //             itemScrollController:
                                                //                 _scrollController,
                                                //             itemCount: arr.length,
                                                //             itemBuilder:
                                                //                 (context, index) {
                                                //               descriptionController.add(
                                                //                   new TextEditingController());
                                                //               labelController.add(
                                                //                   new TextEditingController());

                                                //    return
                                                ListView.builder(
                                                    itemCount:
                                                        count, //arr.length,
                                                    //selectedUserss.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          _AddMetadataField1(
                                                            labelController[ggg]
                                                                [index],
                                                            descriptionController[
                                                                ggg][index],
                                                            index,
                                                            ggg,
                                                            filename,
                                                            hash,
                                                            mark,
                                                            () {
                                                              setState(() {});
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    }))
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      )),
                  SizedBox(
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        SizedBox(
                          height: 60,
                          width: 130,
                          child: IgnorePointer(
                              ignoring: !ignoreval2,
                              child: ProgressButton(
                                  color: ignoreval2 == false
                                      // filename == null ||
                                      //         ignorevalue == "" ||
                                      //         labelController == null
                                      ? Colors.grey
                                      : Color(0xffff073d83),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  strokeWidth: 2,
                                  child: Text(
                                    "$Stamplabel".toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onPressed: (v) {
                                    Navigator.pop(context);
                                    Index.add(Index);
                                    Dailog_toast().showAlertDialog(context);
                                    mark == "Signature"
                                        ? getHttp()
                                        : getHttp1("hj");
                                    //  submitdata = true;
                                  })),
                        ),
                      ],
                    ),
                  ),
                ]);
              });
        });
  }

  List<TextEditingController> addtextEdit() {
    return [TextEditingController()];
  }

  _AddMetadataField(Controller, Controller1, index, index1, filename, hash) {
    // _value(Controller, Controller1, index, index1, filename, hash);
    //  print("dcnjd:$index");
    return Builder(builder: (context) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: // labelController1,

                        Controller,
                    onChanged: (v) {
                      // setState(() {
                      String a = Controller.text;

                      var labeltext = a.trim();
                      label.add(labeltext); //Controller.text;
                      //  });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      enabled: index == 0 || index == 1 ? false : val,
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Colors.grey // Color(0xffff073D83),
                              )),
                      hintText: "Label ",
                      labelStyle: const TextStyle(
                          color: Colors.grey // Color(0xffff073D83),
                          ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid Label';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: Controller1,
                    onChanged: (v) {
                      //  setState(() {
                      String a = Controller1.text;
                      var desctext = a.trim();
                      desc.add(desctext); //Controller.text;
                      //  });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      enabled: index == 0 || index == 1 ? false : val,
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              // ignore: use_full_hex_values_for_flutter_colors
                              color: Colors.grey //Color(0xffff073D83),
                              )),
                      hintText: "Description ",
                      labelStyle: const TextStyle(
                          color: Colors.grey // Color(0xffff073D83),
                          ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid Description';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        index == 0 || index == 1 ? print("") : name1.add(index);
                        a = true;
                      });
                    }, //_incrementEnter,
                    onExit: (event) {
                      setState(() {
                        index == 0 || index == 1
                            ? print("")
                            : name1.remove(index);
                        a = false;
                      });
                    }, //_incrementEnterr,
                    child: IconButton(
                      onPressed: () {
                        count = a1[index1];
                        if (count > 2) {
                          setState(() {
                            count--;
                            a1[index1] = count;
                            count = a1[index1];
                            labelController[index].clear();
                            descriptionController[index].clear();
                          });
                        }
                      },
                      icon: Image.asset(
                        "assets/Images/delete.png",
                        filterQuality: FilterQuality.medium,
                        color: name1.contains(index) ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
        // ),
      );
    });
  }

//download Pdf File code
  bool top = false;
  Future<String> uploadImage2(file, i, List a, name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var align = preferences.getString("align");
    align.contains("top") ? top = true : top = false;
    setState(() {
      val1 = true;
    });

    var n = file.replaceAll("%20", " ");

    //String fileName1 = file.path.split('/').last;

    Response response;
    Map<String, dynamic> metaData = new Map<String, dynamic>();
    // metaData = {"type": "3", "align": top ? "top" : "bottom"};
    metaData = {"type": "3"};
    for (int j = 0; j < a.length; j++) {
      //  metaParams = metaParams + '"${label[i]}"' + ":" + '"${desc[i]}",';

      labelController[i][j].text.contains("Watermark Position") &&
                  descriptionController[i][j].text.contains("Bottom") ||
              descriptionController[i][j].text.contains("Top")
          ? metaData
              .addAll({"align": descriptionController[i][j].text.toLowerCase()})
          : metaData.addAll(
              {labelController[i][j].text: descriptionController[i][j].text});
    }

    var c = metaData;

    var formData = FormData.fromMap(c);
    formData.files.add(MapEntry(
      'attachments',
      MultipartFile.fromFileSync(
        // "C:/Users/Nikhil Deshmukh/Downloads/Untitled document (77).pdf",
        n,
        // file.path,
        filename: name, //fileName1,
        contentType: MediaType(
          lookupMimeType(n).split('/')[0],
          lookupMimeType(n).split('/')[1],
        ),
      ),
    ));
    var ccc = metaData;
    var url = Uri.https(
        '${Backend.baseurl}', '${Backend.createstamp}', {'q': '{https}'});

    var watermark = preferences.getString("watermark");
    token = preferences.getString('token');
    try {
      response = await Dio().post(url.toString(),
          data: formData,
          options: Options(headers: <String, String>{
            "Content-Type": "multipart/form-data",
            HttpHeaders.authorizationHeader: token
          }));
      // ignore: avoid_print

      if (response.statusCode == 200) {
        Navigator.of(context);
        // Navigator.of(context, rootNavigator: true).pop();

        var ab = response.data["data"]["base64"];

        var cc = ab.split(",");
        updateAlbum("ok", "");
        Dailog_toast().showSuccess(context, "Document stamped successfully");

        Future.delayed(const Duration(seconds: 2), () {
          _createFileFromString(cc[1], "$name");
        });
        // arr.clear();
        // labelController.clear();
        Future.delayed(const Duration(seconds: 2), () {
          _clear();
        });
      }
    } on DioError catch (e) {
      //  Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        //   arr.clear();
        filename = null;
        val1 = false;
      });
      Navigator.of(context).maybePop();
      Dailog_toast().showError(context, e.response.data['message']);
    }
    // return response;
  }

  _clear() {
    setState(() {
      text = "Drop your file or click here";
      filename = null;

      labelController.clear();
      descriptionController.clear();
    });
  }

  var platform;
  Future<String> _createFileFromString(filee, name) async {
    filename == null;
    final encodedStr = "$filee";
    Uint8List bytes = base64.decode(encodedStr);
    //String dir = (await getApplicationDocumentsDirectory()).path;
    final dir = dirpaths == null || dirpaths == ''
        ? (await getDownloadsDirectory()).path
        : dirpaths;

    var Filepath = Uri.file(dir, windows: true);

    File file = File("$dir/" + "$name");

    //String dirpath = Filepath.toString();
    String dirpath = Filepath.toString();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xffff073d83),
        content: Row(
          children: [
            Expanded(
              child: Text('File Saved Successfully on directory path :$file'),
            ),
            ButtonBar(
              children: [
                // platform == null
                //     ? OutlinedButton(
                //         onPressed: () {
                //           _makeCall(
                //               "${dirpath.replaceAll("%20", " ")}\\" + "$name");
                //         },
                //         child: const Text("Open File"))
                //     : const SizedBox(),
                OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text("Dismiss"))
              ],
            )
          ],
        ), //

        duration: const Duration(seconds: 5),
      ),
    );
    filename = null;
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> _makeCall(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        enableDomStorage: true,
        // forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  List<PlatformFile> checkpath = [];
  List checkpath1 = [];
  List dpath = [];
  var bbb;
  bool mark;
  void getHttp() async {
    for (var j = 0; j < labelController.length; j++) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var watermark = preferences.getString("watermark");

      var checkname = descriptionController[j][0].text;

      watermark == "1"
          ? setState(() {
              checkname.contains(".pdf") //|| selectfile.contains(".pdf")
                  ? {
                      mark = true,
                      dpath.clear(),
                      // checkpath1.clear(),
                      // bbb = _paths1.map((e) => e.name).toList()[j].toString() ==
                      //         null
                      //     ? _paths1.map((e) => e.name).toList()[0].toString()
                      //     : _paths1.map((e) => e.name).toList()[j].toString(),
                      checkname == descriptionController[j][0].text
                          ? dpath.add(pathhhhhh[j])
                          : print("")
                    }
                  : mark = false;
              mark
                  ? uploadImage2(dpath[0], j, labelController[j], checkname)
                  : updateAlbum1(j, labelController[j]);
            })
          : updateAlbum1(j, labelController[j]);
    }
  }

  void getHttp1(pdf) async {
    for (var j = 0; j < labelController.length; j++) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var watermark = preferences.getString("watermark");

      var checkname = descriptionController[j][0].text;
      pdf == "withPdf"
          ? watermark == "1"
              ? setState(() {
                  checkname.contains(".pdf") //|| selectfile.contains(".pdf")
                      ? {
                          mark = true,
                          dpath.clear(),
                          checkname == descriptionController[j][0].text
                              ? dpath.add(pathhhhhh[j])
                              : print("")
                        }
                      : mark = false;
                  mark
                      ? uploadImage2(dpath[0], j, labelController[j], checkname)
                      : print("");
                })
              : print("")
          : updateAlbum1(j, labelController[j]);
    }
  }

  void ignoreButton() {
    ignoreval2 = true;
    for (int g = 0; g < labelController.length; g++) {
      var uuu = labelController[g];
      if (uuu.where((i) => i.text.trim() == "").isNotEmpty) {
        ignoreval2 = false;
      }

      var ddd = descriptionController[g];
      if (ddd.where((i) => i.text.trim() == "").isNotEmpty) {
        ignoreval2 = false;
      }
    }
  }

//Single metadata file list
  final _currencies = [
    "Top",
    "Bottom",
  ];

  // ignore: non_constant_identifier_names
  _AddMetadataField1(Controller, Controller1, index, section, filename, hash,
      mark, DesignUpdation updateDesign) {
    _value1(Controller, Controller1, index, section, filename, hash, mark);

    return StatefulBuilder(
        key: UniqueKey(),
        builder: (context, setState) {
          return
              //  Form(
              //   key: _formKeys[section],
              //   child:
              Column(
            children: [
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            controller: // labelController1,

                                Controller,
                            onChanged: (v) {
                              ignoreButton();
                              updateDesign();
                            },
                            onTap: () {
                              temptext = Controller;
                            },
                            autofocus: temptext == Controller ? true : false,
                            decoration: InputDecoration(
                              isDense: true,
                              enabled: index == 2 && mark == "Signature"
                                  ? index < 2
                                  : index == 0 || index == 1
                                      ? false
                                      : true,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      // ignore: use_full_hex_values_for_flutter_colors
                                      color: Colors.grey // Color(0xffff073D83),
                                      )),
                              //focusedBorder: OutlineInputBorder( borderSide: new BorderSide(color: Colors.grey)),
                              // labelText: "Label ",
                              hintText: "Label",
                              labelStyle: const TextStyle(
                                  color: Colors.grey // Color(0xffff073D83),
                                  ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid Label';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: index == 2 && mark == "Signature"
                              ? FormField(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          focusColor: Colors.white,
                                          isDense: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      isEmpty: _currentSelectedValue == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value:
                                              _currentSelectedValue, // _currencies[0],
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _currentSelectedValue = newValue;

                                              Controller1.text = newValue;
                                              ignoreButton();

                                              // state.didChange(newValue);
                                            });
                                          },
                                          items:
                                              _currencies.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : TextFormField(
                                  controller: Controller1,
                                  onChanged: (v) {
                                    ignoreButton();
                                    updateDesign();
                                  },
                                  onTap: () {
                                    temptext = Controller1;
                                  },
                                  autofocus:
                                      temptext == Controller1 ? true : false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    enabled:
                                        index == 0 || index == 1 ? false : true,

                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            // ignore: use_full_hex_values_for_flutter_colors
                                            color: Colors
                                                .grey //Color(0xffff073D83),
                                            )),
                                    //focusedBorder: OutlineInputBorder( borderSide: new BorderSide(color: Colors.grey)),
                                    hintText: "Description ",
                                    labelStyle: const TextStyle(
                                        color:
                                            Colors.grey // Color(0xffff073D83),
                                        ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter valid Description';
                                    }
                                    return null;
                                  },
                                ),
                        ),
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: MouseRegion(
                            onEnter: (event) {
                              setState(() {
                                index == 2 && mark == "Signature"
                                    ? index == 0 || index == 1 || index == 2
                                    : index == 0 || index == 1
                                        ? print("")
                                        : name1.add(index);
                                // name1.add(index);

                                // index == 0 || index == 1 ? print("") :

                                a = true;
                              });
                            }, //_incrementEnter,
                            onExit: (event) {
                              setState(() {
                                index == 2 && mark == "Signature"
                                    ? index == 0 || index == 1 || index == 2
                                    : index == 0 || index == 1
                                        ? print("")
                                        : name1.remove(index);

                                a = false;
                              });
                            }, //_incrementEnterr,
                            child: IconButton(
                              //  color: name.contains(index) ? Colors.red : Colors.grey,
                              onPressed: () {
                                ct = a1[section];
                                index == 2 && mark == "Signature"
                                    ? index == 0 || index == 1 || index == 2
                                    : index == 0 || index == 1
                                        ? print("")
                                        : {
                                            if (ct > 2)
                                              {
                                                ct--,
                                                a1[section] = ct,
                                                labelController[section]
                                                    .removeAt(index),
                                                descriptionController[section]
                                                    .removeAt(index),
                                              },
                                            name1.clear(),
                                            ignoreButton(),
                                            updateDesign()
                                          };
                              },
                              icon: Image.asset(
                                "assets/Images/delete.png",
                                filterQuality: FilterQuality.medium,
                                color: name1.contains(index)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
            //  ),
          );
        });
  }
}

typedef DesignUpdation = void Function();
