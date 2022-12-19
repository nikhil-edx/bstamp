// import 'package:flutter/material.dart';

// class ElectronicSignature extends StatefulWidget {
//   const ElectronicSignature({Key key}) : super(key: key);

//   @override
//   _ElectronicSignatureState createState() => _ElectronicSignatureState();
// }

// class _ElectronicSignatureState extends State<ElectronicSignature> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_string_interpolations
import 'dart:typed_data';

//import 'package:path/path.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend.dart';
import '../edexa_login.dart';
import '../main.dart';
import 'dialog_toast.dart';

class Electronic_Signature extends StatefulWidget {
  const Electronic_Signature({Key key}) : super(key: key);

  @override
  _Electronic_SignatureState createState() => _Electronic_SignatureState();
}

class _Electronic_SignatureState extends State<Electronic_Signature> {
  // ignore: prefer_final_fields
  ItemScrollController _scrollController = ItemScrollController();
  var pageImage, pageImagee, dirpaths;
  // ignore: unused_field
  String _fileName;
  List<PlatformFile> _paths;
  var hash1;
  // ignore: non_constant_identifier_names
  File Attachment;
  List arr = [];
  List<String> label = [];
  List desc = [];
  var uri;
  bool submitdata = false;
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  String filename, text;
  var color;
  var watermark, watermarkPosition;
  void httpJob(AnimationController controller) async {
    controller.forward();

    controller.reset();
  }

  @override
  void initState() {
    super.initState();
    setpath();
  }

  setpath() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dirpaths = preferences.getString("Dir");
  }

  List pathhhhhh = [];
  void _openFileExplorer() async {
    label.clear();
    desc.clear();
    pageImage = null;
    pathhhhhh.clear();

    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        // ignore: avoid_print
        onFileLoading: (FilePickerStatus status) => print(""),
      ))
          ?.files;

      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // print("Unsupported operation" + e.toString());
    } catch (ex) {
      // print(ex);
    }
    if (!mounted) return;
    setState(() {
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
      var fileType = _fileName.split('.');
      final path = _paths.map((e) => e.path).toList()[0].toString();

      filename = _paths.map((e) => e.name).toList()[0].toString();
      filename == null
          ? text = "Drop your file or click here"
          : text = filename;
      final bytes = File(path).readAsBytesSync();
      uri = lookupMimeType(path);
      uri == null
          ? Dailog_toast()
              .showError(context, "This file format is not supported")
          : print("");
      String base64Image = "data:$uri;base64," + base64Encode(bytes);
      pathhhhhh.add(_paths[0].path);
      hash(base64Image, filename);
    });
  }

  int y = 0;
  var viewType;
  int viewtypeindex;
  hash(var id, filename) async {
    i = 2;
    arr.add(0);
    arr.add(1);
    // arr.add(3);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    watermark = preferences.getString('watermark');
    viewType = preferences.getString('viewType');
    watermark == "1" && filename.contains(".pdf") ? arr.add(2) : print("");
    viewtypeindex = int.parse(viewType);
    watermarkPosition = preferences.getString('align');

    var bytes = utf8.encode(id); // data being hashed
    // ignore: unused_local_variable
    var digest = sha1.convert(bytes);
    hash1 = sha256.convert(bytes);
    setState(() {
      var a = hash1;
      watermark == "1" && filename.contains(".pdf")
          ? {
              y = 8,
              label.add("Watermark Position"),
              desc.add(
                  watermarkPosition == "none" ? "bottom" : watermarkPosition)
            }
          : {y = 7, SizedBox()};

      label.add("filename");
      desc.add(filename);
      label.add("hash");
      watermark == "0"
          ? desc.add("$a")
          : filename.contains(".pdf")
              ? desc.add("PDF file with stamp")
              : desc.add("$a");
      watermark == "1" &&
              watermarkPosition == "none" &&
              filename.contains(".pdf")
          ? showWatermark(context, () {
              setState(() {});
            })
          : print("");
      // add();
    });
  }

  String token;

  var myDatat;
  updateAlbum0(id, text) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var url = Uri.https(
        // ignore: unnecessary_string_interpolations
        '${Backend.baseurl}',
        // ignore: unnecessary_string_interpolations
        '${Backend.download}',
        {'q': '{https}'});
    // ignore: unused_local_variable
    final http.Response response = await http
        .put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: token
      },
      body: jsonEncode({"viewType": id, "align": text}),
      // ignore: missing_return
    )
        // ignore: missing_return
        .then((response) {
      if (response.statusCode == 200) {
        // Navigator.of(context, rootNavigator: true).pop();

        setState(() {
          myDatat = json.decode(response.body);

          preferences.setString(
              "viewType", myDatat['data']['viewType'].toString());
          preferences.setString("align", myDatat["data"]["align"].toString());

          // Dailog_toast().showSuccess(context, myDatat["message"]);
        });
      } else {
        myDatat = json.decode(response.body);
      }
    });
  }

  Future<String> uploadImage2(file) async {
    var n = file.replaceAll("%20", " ");
    // String fileName1 = file.path.split('/').last;

    Response response;
    Map<String, dynamic> metaData = new Map<String, dynamic>();
    // metaData = {"type": "3", "align": top ? "top" : "bottom"};
    metaData = {"type": "3", "align": watermarkPosition};
    for (int i = 0; i < label.length; i++) {
      label[i].contains("Watermark Position") && desc[i].contains("bottom") ||
              desc[i].contains("top")
          ? print("")
          : metaData.addAll({
              label[i].trim():
                  desc[i] == "PDF file with stamp" ? hash1 : desc[i].trim()
            });
    }
    var c = metaData;

    var formData = FormData.fromMap(c);
    formData.files.add(MapEntry(
      'attachments',
      MultipartFile.fromFileSync(
        // file.path,
        n,
        filename: filename,
        contentType: MediaType(
          lookupMimeType(n).split('/')[0],
          lookupMimeType(n).split('/')[1],
        ),
      ),
    ));

    var url = Uri.https(
        '${Backend.baseurl}', '${Backend.createstamp}', {'q': '{https}'});
    SharedPreferences preferences = await SharedPreferences.getInstance();
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
        updateAlbum0(
            viewtypeindex,
            savedLater == false
                ? "none"
                : top == true
                    ? "top"
                    : "bottom");
        Navigator.of(context, rootNavigator: true).pop();
        var ab = response.data["data"]["base64"];
        var cc = ab.split(",");

        Dailog_toast().showSuccess(context, "Document stamped successfully");

        Future.delayed(const Duration(seconds: 1), () {
          _createFileFromString(cc[1], "$filename");
        });

        arr.clear();
        labelController.clear();
        Future.delayed(const Duration(seconds: 1), () {
          _clear();
        });
      }
    } on DioError catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        arr.clear();
        filename = null;
        labelController.clear();
        descriptionController.clear();
      });

      Dailog_toast().showError(context, e.response.data['message']);
    }
    // return response;
  }
// Save file dailog box

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

    String dirpath = Filepath.toString();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xffff073D83),
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
                //           // _makeCall(dirpath.replaceAll("%20", " "));
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

        duration: const Duration(seconds: 15),
      ),
    );
    filename = null;
    await file.writeAsBytes(bytes);
    return file.path;
    // User canceled the picker
  }

  Future<void> _makeCall(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        enableDomStorage: true,
        //forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  bool mark;
  void getHttp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var watermark = preferences.getString("watermark");

    watermark == "1"
        ? setState(() {
            filename.contains(".pdf") ? mark = true : mark = false;
            mark ? uploadImage2(pathhhhhh[0]) : updateAlbum();
          })
        : updateAlbum();
  }

  Future updateAlbum() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var url = Uri.https(
        '${Backend.baseurl}', '${Backend.createstamp}', {'q': '{https}'});
    String metaParams = '"type":' + '"3",';
    for (int i = 0; i < label.length; i++) {
      // metaParams = metaParams + '"${label[i]}"' + ":" + '"${desc[i]}",';
      Map<String, String> map = {label[i]: desc[i]};
    }
    Map<String, dynamic> metaData = new Map<String, dynamic>();
    metaData = {'type': "3"};
    for (int i = 0; i < label.length; i++) {
      label[i].contains("Watermark Position") && desc[i].contains("bottom") ||
              desc[i].contains("top")
          ? print("")
          :
          // metaParams = metaParams + '"${label[i]}"' + ":" + '"${desc[i]}",';
          metaData.addAll({label[i].trim(): desc[i].trim()});
      // metaData = {label[i]: desc[i]};
    }
    // ignore: unused_local_variable
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
          Navigator.of(context, rootNavigator: true).pop();
          Dailog_toast().showSuccess(context, "Document stamped successfully");
          // _dialog(1, "Document stamped successfully");
          filename = null;
          // ignore: unused_local_variable
          var myData = json.decode(response.body);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabBarDemo(
                        selectedPage: 1,
                      )));
        });
      }else {
        Navigator.of(context, rootNavigator: true).pop();

        _clear();
        var errormsg = json.decode(response.body);

        Dailog_toast().showError(context, errormsg["message"]);
      }
    });
  }

  _clear() {
    setState(() {
      text = "Drop your file or click here";
      filename = null;

      labelController.clear();
      descriptionController.clear();
    });
  }

  List<TextEditingController> labelController = new List();
  List<TextEditingController> descriptionController = new List();

  List name = [];
  bool val = false;
  var labeltext = "labeltext";
  var desctext = "desctext";
  _value(Controller, Controller1, index) {
    if (filename.contains(".pdf") ? arr.length == 3 : arr.length == 2) {
      val = false;
      labelController[index].text = label[index];
      descriptionController[index].text = desc[index];
      labeltext = labelController[index].text;
      desctext = descriptionController[index].text;
      final path1 = label.map((e) => e).toList()[index].toString();
    } else {
      val = true;

      labeltext = Controller.text;
      desctext = Controller1.text;
    }
  }

  bool ignoreval2 = false;
  bool ignoreval1 = false;

  // ignore: non_constant_identifier_names
  _AddMetadataField(
    Controller,
    Controller1,
    index,
  ) {
    _value(Controller, Controller1, index);

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
                  // inputFormatters: [
                  //    //NoLeadingSpaceFormatter(),
                  //  // FilteringTextInputFormatter.deny(RegExp('[ ]'))
                  // ],
                  controller: // labelController1,

                      Controller,
                  onChanged: (v) {
                    setState(() {
                      String a = Controller.text;
                      labeltext = a.trim();
                      labeltext.isNotEmpty
                          ? ignoreval2 = false
                          : ignoreval2 = true;
                      // label.add(labeltext); //Controller.text;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,

                    enabled: filename.contains(".pdf")
                        ? index == 0 || index == 1 || index == 2
                            ? false
                            : true
                        : index == 0 || index == 1
                            ? false
                            : val,

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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
                    // FilteringTextInputFormatter.deny(' ')
                    //  FilteringTextInputFormatter.deny(RegExp('[ ]'))
                  ],
                  controller: Controller1,
                  onChanged: (v) {
                    setState(() {
                      String a = Controller1.text;
                      desctext = a.trim();

                      desctext.isNotEmpty
                          ? ignoreval1 = false
                          : ignoreval1 = true;
                      // label.add(labeltext); //Controller.text;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    enabled: filename.contains(".pdf")
                        ? index == 0 || index == 1 || index == 2
                            ? false
                            : true
                        : index == 0 || index == 1
                            ? false
                            : val,

                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            // ignore: use_full_hex_values_for_flutter_colors
                            color: Colors.grey //Color(0xffff073D83),
                            )),
                    //focusedBorder: OutlineInputBorder( borderSide: new BorderSide(color: Colors.grey)),
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
                      filename.contains(".pdf")
                          ? index == 0 || index == 1 || index == 2
                              ? print("")
                              : name.add(index)
                          : index == 0 || index == 1
                              ? print("")
                              : name.add(index);
                      a = true;
                    });
                  }, //_incrementEnter,
                  onExit: (event) {
                    setState(() {
                      filename.contains(".pdf")
                          ? index == 0 || index == 1
                              ? print("")
                              : name.remove(index)
                          : index == 0 || index == 1
                              ? print("")
                              : name.remove(index);
                      a = false;
                    });
                  }, //_incrementEnterr,
                  child: IconButton(
                    color: name.contains(index) ? Colors.red : Colors.grey,
                    onPressed: () {
                      name.contains(index) ? name.remove(index) : print("");

                      a = false;

                      i = 0;

                      filename.contains(".pdf") && index == 0
                          ? showWatermark(context, () {
                              setState(() {});
                            })
                          : filename.contains(".pdf")
                              ? watermarkpdf(index)
                              : _incrementEnterr(index);
                    },
                    icon: filename.contains(".pdf") && index == 0
                        ? Icon(Icons.edit)
                        : Image.asset(
                            "assets/Images/delete.png",
                            filterQuality: FilterQuality.medium,
                            color:
                                name.contains(index) ? Colors.red : Colors.grey,
                          ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void watermarkpdf(index) {
    setState(() {
      index == 0 || index == 1 || index == 2
          ? print("")
          : arr.contains(index)
              ? arr.removeAt(index)
              : arr.removeAt(index);

      index == 0 || index == 1 || index == 2
          ? print("")
          : labelController.removeAt(index); //[index].clear();
      index == 0 || index == 1 || index == 2
          ? print("")
          : descriptionController.removeAt(index);
      index == 0 || index == 1 || index == 2
          ? print("")
          : labeltext = labelController[index - 1].text;
    });
  }

  void _incrementEnterr(index) {
    index == 0 && index == 1
        ? print("")
        : setState(() {
            index == 0 || index == 1
                ? print("")
                : arr.contains(index)
                    ? arr.removeAt(index)
                    : arr.removeAt(index);

            index == 0 || index == 1
                ? print("")
                : {
                    // labelController[index].clear(),
                    labelController.removeAt(index)
                  };
            index == 0 || index == 1
                ? print("")
                : {
                    //descriptionController[index].clear(),
                    descriptionController.removeAt(index)
                  };
            index == 0 || index == 1
                ? print("")
                : labeltext = labelController[index - 1].text;
          });
  }

  bool a = false;
  int i = 0;
  final _height = 80;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stamp your documents",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                      // fontStyle: FontStyle.normal,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0, left: 1.0, right: 1.0),
                  child: DottedBorder(
                    color: Colors.grey.shade400, //Color(0xFFDADCE0),
                    strokeWidth: 1,
                    strokeCap: StrokeCap.round,
                    dashPattern: [5],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    child: DropTarget(
                      onDragDone: (detail) {
                        setState(() {
                          final c = detail.files[0].path;
                          String d = c.replaceAll(
                              "%20", " "); //c.replaceFirst("/", "");
                          // filename = detail.map((e) => e.name).toList()[0].toString();
                          final bytes = File("${d}").readAsBytesSync();
                          //  filename = c.split("/").last;
                          filename = c.split("/").last.replaceAll("%20", " ");

                          uri = lookupMimeType(c);
                          uri == null
                              ? Dailog_toast().showError(
                                  context, "This file format is not supported")
                              : print("");
                          String base64Image =
                              "data:$uri;base64," + base64Encode(bytes);
                          pathhhhhh.add(detail.files[0].path);

                          hash(base64Image, filename);

                          // _list.addAll(detail.urls);
                        });
                      },
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            arr.clear();
                            _openFileExplorer();
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 11,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey.shade100.withOpacity(0.7),
                          ),
                          child: Center(
                              child: filename == null
                                  ? const Text("Drop your file or click here",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 25,
                                      ))
                                  : Text(
                                      "$filename",
                                      style: TextStyle(fontSize: 15),
                                    )),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 0.0, bottom: 10),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                              text: "Your document will get stamped in",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: " Blockchain",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey))
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                arr.length == 0 || filename == null
                    ? Container()
                    : Row(
                        children: [
                          const Text("Stamp Metadata",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Spacer(),
                          InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () {
                              arr.length != 8
                                  ? setState(() {
                                      labeltext = null;
                                      desctext = null;
                                      var c = arr.length;
                                      filename == null ? "" : arr.add(c);

                                      i++;
                                      _scrollController.scrollTo(
                                          index: c,
                                          duration: Duration(seconds: 1));
                                    })
                                  : print("");
                            },
                            child: MouseRegion(
                              onEnter: (e) {
                                setState(() {
                                  color = Color(0xffff005397);
                                });
                              },
                              onExit: (e) {
                                setState(() {
                                  color = Color(0xffff073D83);
                                });
                              },
                              child: Text(arr.length != y ? "Add Metadata" : "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      // ignore: use_full_hex_values_for_flutter_colors
                                      color: filename == null
                                          ? Colors.grey
                                          : color //Color(0xffff005397)
                                      )),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 20,
                ),
                arr.length == 0 || filename == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0,
                            left: 1.0,
                            right: 1.0), //const EdgeInsets.all(12.0),
                        child: Wrap(
                          children: [
                            Container(
                              height: arr.length == 0
                                  ? 50
                                  : arr.length == 2
                                      ? 160
                                      : 240, //MediaQuery.of(context).size.height / 3,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: arr.length == 0
                                  ? const Center(
                                      child: Text(
                                        "Not added any metatdata, click to add metadata",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : Scrollbar(
                                      showTrackOnHover: true,
                                      // isAlwaysShown: true,
                                      hoverThickness: 10,
                                      interactive: true,
                                      child: ScrollablePositionedList.builder(
                                          initialScrollIndex: 0,
                                          itemScrollController:
                                              _scrollController,
                                          //  controller: _controller,
//reverse: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: arr.length, //i,
                                          itemBuilder: (context, index) {
                                            descriptionController.add(
                                                new TextEditingController());
                                            labelController.add(
                                                new TextEditingController());

                                            return Column(
                                              children: [
                                                _AddMetadataField(
                                                  labelController[index],
                                                  descriptionController[index],
                                                  index,
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                            ),
                          ],
                        ),
                      ),
                arr.length == 0 || filename == null || arr.length == y
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      "You can add more information by clicking on",
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(
                                  text: " Add Metadata",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey))
                            ],
                          ),
                        )),
                SizedBox(
                  height: filename == null ? 0 : 40,
                ),
                Text(
                  "Electronic Signature",
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      // fontStyle: FontStyle.normal,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: "Note:",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text:
                              " The file stamp feature will be enabled for any type of file.",
                          style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
                Switch(
                  hoverColor: Colors.transparent,
                  value: true, //_switchValue,
                  inactiveTrackColor:
                      const Color(0xffff073D83).withOpacity(0.5),
                  inactiveThumbColor: const Color(0xffff073D83),
                  // onChanged: (value) {

                  // },
                  activeTrackColor: const Color(0xffff073D83).withOpacity(0.5),
                  activeColor: const Color(0xffff073D83),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 60,
                      width: 130,
                      child: IgnorePointer(
                          ignoring: filename == null ||
                                  labeltext == '' ||
                                  desctext == '' ||
                                  uri == null ||
                                  ignoreval1 ||
                                  ignoreval2
                              ? true
                              : false,
                          child: ProgressButton(
                              color: filename == null ||
                                      labeltext == '' ||
                                      desctext == '' ||
                                      uri == "" ||
                                      uri == null ||
                                      ignoreval1 ||
                                      ignoreval2
                                  ? Colors.grey
                                  : Color(0xffff073D83),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              strokeWidth: 2,
                              child: Text(
                                "Stamp".toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: (v) {
                                if (_formKey.currentState.validate()) {
                                  submitdata = true;
                                  for (int i = 0; i < arr.length; i++) {
                                    label.addAll({labelController[i].text});
                                    desc.addAll(
                                        {descriptionController[i].text});
                                  }

                                  Dailog_toast().showAlertDialog(context);
                                  getHttp();
                                }
                              })
                          // filename != null && labeltext != null
                          //       ? (AnimationController controller) async {

                          //            Dailog_toast().showAlertDialog(context);
                          //            getHttp();

                          //           //  httpJob(controller);
                          //           // ScaffoldMessenger.of(context).showSnackBar(
                          //           //   const SnackBar(
                          //           //       content: Text('Processing Data...')),
                          //           // );
                          //         }
                          //       : null),
                          ),
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool top = false;
  bool bottom = false;
  bool savedLater = true;
  GlobalKey key = GlobalKey();
  void showWatermark(BuildContext context, DesignUpdation updateDesign) {
    watermarkPosition == "top"
        ? {
            top = true,
            bottom = false,
          }
        : {bottom = true, top = false};
    showDialog(
        useRootNavigator: false,
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
              //   key: UniqueKey(),
              builder: (context, setState) {
            return AlertDialog(actions: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        top
                            ? Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue)))
                            : SizedBox(),
                        Container(
                            key: key,
                            height: MediaQuery.of(context).size.height / 1.6,
                            child: Image.network(
                              "https://edexa-portal-beta.s3.ap-south-1.amazonaws.com/watermark.png",
                            )
                            //  Image.memory(
                            //   bytes,
                            //   fit: BoxFit.cover,
                            // ),
                            ),
                        bottom
                            ? Align(
                                alignment: Alignment
                                    .bottomCenter, //Alignment(-1.0, 1.0)
                                child: Container(
                                  padding:
                                      EdgeInsets.only(left: 200, right: 300),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue)),
                                  height: 50,
                                ))
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const Text(
                                "Watermark Position ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 2.0, color: Colors.grey),
                                ),

                                checkColor: Colors.blue,
                                hoverColor: Colors.transparent,
                                activeColor: Colors.transparent,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,

                                value: top,
                                // id,
                                onChanged: (val) {
                                  setState(() {
                                    watermarkPosition = "top";
                                    top = true;
                                    bottom = false;
                                    desc.replaceRange(0, 0 + 1, ["top"]);
                                  });
                                },
                              ),
                              const Text(
                                'Top ',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 2.0, color: Colors.grey),
                                ),
                                checkColor: Colors.blue,
                                hoverColor: Colors.transparent,
                                activeColor: Colors.transparent,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: bottom,
                                onChanged: (val) {
                                  setState(() {
                                    watermarkPosition = "bottom";
                                    top = false;
                                    bottom = true;
                                    desc.replaceRange(0, 0 + 1, ["bottom"]);
                                  });
                                },
                              ),
                              const Text(
                                'Bottom',
                                style: TextStyle(fontSize: 17.0),
                              ),
                              Checkbox(
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 2.0, color: Colors.grey),
                                ),

                                checkColor: Colors.blue,
                                hoverColor: Colors.transparent,
                                activeColor: Colors.transparent,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,

                                value: savedLater,
                                // id,
                                onChanged: (val) {
                                  setState(() {
                                    savedLater == false
                                        ? savedLater = true
                                        : savedLater = false;

                                    // top = true;
                                    // bottom = false;
                                    // desc.replaceRange(0, 0 + 1, ["top"]);
                                  });
                                },
                              ),
                              const Text(
                                'Save option for later',
                                style: TextStyle(fontSize: 17.0),
                              ),
                              Spacer(),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                        Size.fromHeight(40),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xffff073D83)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(10))),
                                  onPressed: () {
                                    setState(() {
                                      watermarkPosition = watermarkPosition;
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "     Done     ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ]);
          });
        });
  }

  final _controller = ScrollController();
  _animateToIndex(i) => _controller.animateTo(_height * i,
      duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
}

typedef DesignUpdation = void Function();
