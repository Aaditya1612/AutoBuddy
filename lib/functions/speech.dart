// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_field, unused_local_variable, unused_element, prefer_final_fields, prefer_typing_uninitialized_variables, must_be_immutable, await_only_futures, unused_import

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:vibration/vibration.dart';
import 'nearbyUsers.dart';

class ServiceActivator extends StatefulWidget {
  const ServiceActivator(
      {super.key, required this.cameras, required this.sms_sender});

  final cameras;
  final sms_sender;

  @override
  State<ServiceActivator> createState() => _ServiceActivatorState();
}

class _ServiceActivatorState extends State<ServiceActivator> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  AudioPlayer audioPlayer = AudioPlayer();
  String sta = "done";
  String out = "0";
  int threat = 0;
  late String filePath = "";
  int isfallen = 0;
  bool canShowAppPrompt = true;
  bool isRunning = false;
  late Timer cooldowntimer;
  bool onchange = false;
  late Timer timer;
  late double latitude;
  late double longitude;
  late String userName;
  bool langLoad = false;
  String lang = "";
  bool isActive = false;

  // This function ask for Permissions and give status of it
  void _setupSpeechRecognition() async {
    fall_detection();
    bool available = await _speech.initialize(
      onStatus: (status) {
        // print('Speech recognition status: $status');
      },
      onError: (error) {
        // print('Speech recognition error: $error');
        _startListening();
      },
    );
    if (available) {
      print('Speech recognition is available');
      _startListening();
    } else {
      // print('Speech recognition is not available');
    }
  }

// This function is to SEND DATA AND RECIEVE THE PREDICTED OUTPUT
  void data_from_api(String text) async {
    final csvString = await rootBundle.loadString('assets/dataset.csv');
    final csvData = const CsvToListConverter().convert(csvString);
    for (final row in csvData) {
      if (row.isNotEmpty) {
        String string1 = row[0].toString().toLowerCase();
        var similarity = text.similarityTo(string1);
        if (similarity >= 0.6 && canShowAppPrompt == true) {
          print(similarity);
          startTimer();
          startCooldown();
          break;
        }
      }
    }
  }

// THIS FUNCTION LISTEN TO THE MICROPHONE AND GIVE THE TEXT GENERATED
  void _startListening() {
    _speech.listen(
      listenFor: const Duration(seconds: 5),
      onResult: (result) {
        if (result.finalResult) {
          String text = result.recognizedWords;
          print('Recognized text: $text');
          data_from_api(text.toLowerCase());
        }
        if (!_speech.isListening || sta == "done") {
          _startListening();
        }
      },
    );
  }

  // This FUNCTION IS FOR THE APP PROMPT
  void startTimer() async {
    _triggerVibration();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Are You Safe?"),
              content: Text("Press Yes to Confirm"),
              actions: <Widget>[
                ElevatedButton(
                    child: Text("YES"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // close the dialog
                      threat = 1;
                      Vibration.cancel();
                      setState(() {
                        canShowAppPrompt = true;
                      });
                    })
              ]);
        });
    await Future.delayed(const Duration(seconds: 10));

    if (threat == 0) {
      print("VOICE THREAT");
      Navigator.of(context, rootNavigator: true).pop();
      Vibration.cancel();
      await fetchLocation();
      if (await _isPermissionGranted()) {
        _sendMessage(
            "+918882774087",
            """Need help My Location is https://www.google.com/maps/place/$latitude+$longitude""",
            1);
        _sendEmailToCommunity();
      }
    } else {
      print("WRONG DETECTION FOR VOICE");
      threat = 0;
      canShowAppPrompt = true;
      Vibration.cancel();
    }
  }

  // Adding Threat data

// Audio Player Function
  void playAudio() async {
    audioPlayer.play(AssetSource('safety.mp3'));
  }

  // This Function Is For FALL DETECTION
  void fall_detection() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      num _accelX = event.x.abs();
      num _accelY = event.y.abs();
      num _accelZ = event.z.abs();
      num x = pow(_accelX, 2);
      num y = pow(_accelY, 2);
      num z = pow(_accelZ, 2);
      num sum = x + y + z;
      num result = sqrt(sum);
      // print("accz = $_accelZ");
      // print("accx = $_accelX");
      // print("accy = $_accelY");
      if ((result < 1) ||
          (result > 70 && _accelZ > 60 && _accelX > 60) ||
          (result > 70 && _accelX > 60 && _accelY > 60)) {
        // print("res = $result");
        // print("accz = $_accelZ");
        // print("accx = $_accelX");
        // print("accy = $_accelY");
        if (canShowAppPrompt) {
          fallTimer();
          startCooldown();
        }
      }
    });
  }

// vibrate triggger
  void _triggerVibration() async {
    final hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 10000);
    }
  }

  // FAll Timer for fall detection
  void fallTimer() async {
    // audioPlayer.play(AssetSource('safety.mp3'));
    _triggerVibration();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Did your phone fall accidently?"),
              content: Text("Press Yes to confirm!"),
              actions: <Widget>[
                ElevatedButton(
                    child: Text("YES"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // close the dialog
                      isfallen = 1;
                      Vibration.cancel();
                      setState(() {
                        canShowAppPrompt = true;
                      });
                    })
              ]);
        });
    await Future.delayed(const Duration(seconds: 10));
    if (isfallen == 0) {
      print("FALL THREAT");
      Navigator.of(context, rootNavigator: true).pop();
      Vibration.cancel();
      await fetchLocation();
      if (await _isPermissionGranted()) {
        _sendMessage(
            "+918638332396",
            """Need help My Location is https://www.google.com/maps/place/$latitude+$longitude""",
            1);
        _sendEmailToCommunity();
      }
    } else {
      print("WRONG DETECTION FOR FALL");
      isfallen = 0;
      canShowAppPrompt = true;
      Vibration.cancel();
    }
  }

  // Cool Down Code Function For App Prompt
  void startCooldown() {
    setState(() {
      canShowAppPrompt = false;
    });
  }

  _getPermission() {
    return Permission.sms.request();
  }

  Future<bool> _isPermissionGranted() {
    return Permission.sms.status.isGranted;
  }

  Future<bool?> get _supportCustomSim {
    return BackgroundSms.isSupportCustomSim;
  }

  _sendEmailToCommunity() async {
    final geo = GeoFlutterFire();
    GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);
    NearbyUsers nbyu = NearbyUsers(center);
    var _currentEntries = nbyu.get();

    _currentEntries.listen((listOfSnapshots) async {
      for (DocumentSnapshot snapshot in listOfSnapshots) {
        Map map = snapshot.data() as Map;
        String mail = map['email'];
        final smtpServer = gmail('helppaws24by7@gmail.com', 'tncucbjrxhuxwoll');
        final message = Message()
          ..from = const Address('helppaws24by7@gmail.com', 'Team AutoBuddy')
          ..recipients.add(mail)
          ..subject = 'Need Help'
          ..html =
              "<p>Someone near your locality needs your help</p><br><b><a href='https://maps.google.com/?q=$latitude,$longitude'>View Location on Google Maps</a></b><br><br>Any help from your side is highly appriciated <br>Regards<br>Team SafeHer";
        try {
          final sendReport = await send(message, smtpServer);
          debugPrint('Mail Sent :)');
        } catch (error) {
          print('Error sending email: $error');
        }
      }
    });
  }

  _sendMessage(String phoneNumber, String message, int simSlot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool contactpckd = await prefs.getBool('contactpckd') ?? false;
    bool emailpckd = await prefs.getBool('emailpckd') ?? false;
    late String num1 = "", num2 = "", num3 = "";
    if (contactpckd) {
      num1 = await prefs.getString('number1').toString().trim();
      num2 = await prefs.getString('number2').toString().trim();
      num3 = await prefs.getString('number3').toString().trim();
    }
    if (num1 != "" && num1 != 'null') {
      var result = await BackgroundSms.sendMessage(
          phoneNumber: "+91+$num1", message: message, simSlot: 1);
      if (result == SmsStatus.sent) {
        print("Sent");
      } else {
        print("Failed");
      }
    }
    if (num2 != "" && num2 != 'null') {
      if (await _isPermissionGranted()) {
        var result1 = await BackgroundSms.sendMessage(
            phoneNumber: "+91+$num2", message: message, simSlot: 1);
        if (result1 == SmsStatus.sent) {
          print("Sent");
        } else {
          print("Failed");
        }
      }
    }
    if (num3 != "" && num3 != 'null') {
      if (await _isPermissionGranted()) {
        var result3 = await BackgroundSms.sendMessage(
            phoneNumber: "+91+$num3", message: message, simSlot: 1);
        if (result3 == SmsStatus.sent) {
          print("Sent");
        } else {
          print("Failed");
        }
      }
    }
  }

  @override
  void initState() {
    langLoad = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            await _getPermission();
            _setupSpeechRecognition();
            setState(() {
              isActive = !isActive;
            });
          },
          child: Icon(Icons.shield),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.all(20)),
            backgroundColor: (isActive)
                ? MaterialStateProperty.all(Colors.green.shade400)
                : MaterialStateProperty.all(Colors.blue), // <-- Button color
          ),
        ),
        SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade800)),
              onPressed: () async {
                await fetchLocation();
                await _sendEmailToCommunity();
                _sendMessage(
                    "+918638332396",
                    """Need help My Location is https://www.google.com/maps/place/$latitude+$longitude""",
                    1);
              },
              child: Text("Manual SOS!")),
        )
      ],
    );
  }

  fetchLocation() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var coll = await FirebaseFirestore.instance
        .collection('userdata')
        .doc(userId)
        .get();

    Map mp = coll.data() as Map;
    GeoPoint currGeo = mp['position']['geopoint'] as GeoPoint;
    userName = mp['firstName'];
    latitude = currGeo.latitude;
    longitude = currGeo.longitude;
  }
}
