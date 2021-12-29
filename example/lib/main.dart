import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:knovi_call/knovi_call.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var buttonText = "Start Call";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const VideoCall(
                  apiKey: "YOUR-VONAGE-API-KEY",
                  sessionId: "YOUR-VONAGE-SESSION-ID",
                  token: "YOUR-VONAGE-SESSION-TOKEN",
                ),
              ),
            );
          },
          child: Text(buttonText),
          color: Colors.grey,
        ),
      ),
    );
  }
}

class VideoCall extends StatefulWidget {
  final String apiKey;
  final String sessionId;
  final String token;

  const VideoCall({
    Key? key,
    required this.apiKey,
    required this.sessionId,
    required this.token,
  }) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KnoviCall(
        apiKey: widget.apiKey,
        sessionId: widget.sessionId,
        token: widget.token,
      ),
    );
  }
}
