import 'dart:async';
import 'dart:io';
import 'dart:math';
// import 'dart:html';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:dress_mate/LoginScreen.dart';
import 'package:dress_mate/SignUpScreen.dart';
import 'package:dress_mate/utils.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:notifications/notifications.dart';
// import 'package:tflite/tflite.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkModeEnabled = false;
  Notifications? _notifications;
  StreamSubscription<NotificationEvent>? _subscription;
  List<NotificationEvent> _log = [];
  bool started = false;

  @override
  void initState() {
    super.initState();
    // startListening();
    initPlatformState();
  }

  // Platf0101orm messages are asynchronous, so we initialize in an async method.1
  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(NotificationEvent event) {
    setState(() {
      if (event.packageName!.contains("in.amazon") ||
          event.packageName!.contains("com.flipkart") ||
          event.packageName!.contains("com.AJIO") ||
          event.packageName!.contains("com.myntra")) {
        _log.add(event);
      }
      print(event.toString());
    });
  }

  void startListening() {
    _notifications = Notifications();
    try {
      _subscription = _notifications!.notificationStream!.listen(onData);
      setState(() => started = true);
    } on NotificationException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
    setState(() => started = false);
  }

  void example() {
    Notifications().notificationStream!.listen((event) => print(event));
  }

  /// Called when the state (day / night) has changed.
  void onStateChanged(bool isDarkModeEnabled) {
    setState(() {
      this.isDarkModeEnabled = isDarkModeEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DressMate',
      theme: ThemeData.light().copyWith(
          // useMaterial3: true,
          ),
      darkTheme: ThemeData.dark().copyWith(
        // useMaterial3: true,
        appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
        scaffoldBackgroundColor: const Color(0xFF15202B),
      ),
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
        switchTheme: DayNightSwitcher(
          isDarkModeEnabled: isDarkModeEnabled,
          onStateChanged: onStateChanged,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final switchTheme;
  const MyHomePage({this.switchTheme});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<PermissionStatus> permissionStatus =
      NotificationPermissions.requestNotificationPermissions(
          openSettings: true);
  List? _result;
  FlutterVision vision = FlutterVision();

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(
        "https://teachablemachine.withgoogle.com/models/UdkLmoCJK/"))) {
      throw Exception('Could not launch');
    }
  }

  void lodaModel() async {
    // await vision.loadTesseractModel(
    //     model: 'assets/model.tflite', labels: 'assets/labels.txt');

    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/model.tflite',
        modelVersion: "yolov5",
        numThreads: 1,
        useGpu: true);
  }

  void initState() {
    super.initState();
    // startListening();
    lodaModel();
  }

  void dispose() async {
    await vision.closeTesseractModel();
    super.dispose();
  }

  void detectCloth(final File img) async {
    var decodedImage = await decodeImageFromList(img.readAsBytesSync());

    var res = await vision.yoloOnImage(
        bytesList: (await img.readAsBytes()),
        imageWidth: decodedImage.width,
        imageHeight: decodedImage.height);

    setState(() {
      _result = res;
      print("RESULTS ARE ::" + res.toString());
    });
  }

  Widget theResult() {
    if (_result == null) {
      return SizedBox();
    }

    return Text(
      _result.toString(),
      style: GoogleFonts.bentham(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1976D2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("DressMate"),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(
                //   height: 250,
                // ),

                Lottie.asset("assets/lottie_mate.json", height: 200),

                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Dress",
                            style: GoogleFonts.bentham(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade700,
                            ),
                          ),
                          Text(
                            "Mate",
                            style: GoogleFonts.bentham(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      theResult(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              changePageTo(
                                  context,
                                  LoginView(
                                    switchTheme: widget.switchTheme,
                                  ),
                                  false);
                            },
                            child: Text("Login"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              changePageTo(context, SignUpScreen(), false);
                            },
                            child: Text("Signup"),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // final List<XFile> images =
                          //     await picker.pickMultiImage();

                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (photo == null) {
                            return null;
                          }
                          var img = File(photo!.path);
                          // detectCloth(img);
                        },
                        child: Text("Try it For Free (Gallery)"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // final List<XFile> images =
                          //     await picker.pickMultiImage();

                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (photo == null) {
                            return null;
                          }
                          var img = File(photo!.path);
                          // detectCloth(img);
                        },
                        child: Text("Try The Model"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // final List<XFile> images =
                          //     await picker.pickMultiImage();

                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.camera);
                          if (photo == null) {
                            return null;
                          }
                          var img = File(photo!.path);
                          // detectCloth(img);
                          if (photo != null) {
                            final result = await vision.tesseractOnImage(
                                bytesList: (await photo.readAsBytes()));
                          }
                        },
                        child: Text("Try it For Free(camera)"),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 300, 0, 0),
                  child: widget.switchTheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
