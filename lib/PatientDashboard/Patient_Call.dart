
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientCallScreen extends StatefulWidget {
  final String patientName;
  final bool isCaller; // <- true for calling, false for receiving

  const PatientCallScreen({
    super.key,
    required this.patientName,
    this.isCaller = false,
  });

  @override
  State<PatientCallScreen> createState() => _PatientCallScreenState();
}

class _PatientCallScreenState extends State<PatientCallScreen> {
  final JitsiMeet jitsiMeet = JitsiMeet();
  late String roomName;
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  bool _isDetecting = false;

  String emotionLabel = "Detecting...";
  String emoji = "";

  @override
  void initState() {
    super.initState();
    roomName = "careconnect_${widget.patientName.replaceAll(' ', '_')}";

    if (widget.isCaller) {
      _triggerCallInFirestore();
      _joinJitsiMuted();
    } else {
      _listenForIncomingCall();
    }

    Future.delayed(const Duration(seconds: 2), _initCameraAndDetector);
  }

  Future<void> _triggerCallInFirestore() async {
    await FirebaseFirestore.instance
        .collection("calls")
        .doc(widget.patientName.replaceAll(' ', '_'))
        .set({
      "roomName": roomName,
      "isActive": true,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  void _listenForIncomingCall() {
    final docRef = FirebaseFirestore.instance
        .collection("calls")
        .doc(widget.patientName.replaceAll(' ', '_'));

    docRef.snapshots().listen((doc) {
      if (doc.exists && doc['isActive'] == true) {
        roomName = doc['roomName'];
        _joinJitsiMuted();
      }
    });
  }

  Future<void> _joinJitsiMuted() async {
    await [Permission.camera, Permission.microphone].request();

    final options = JitsiMeetConferenceOptions(
      room: roomName,
      serverURL: "https://meet.jit.si",
      userInfo: JitsiMeetUserInfo(displayName: "Patient"),
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": true,
      },
      featureFlags: {
        "welcomepage.enabled": false,
        "call-integration.enabled": false,
        "pip.enabled": false,
      },
    );

    await jitsiMeet.join(options);
  }

  Future<void> _initCameraAndDetector() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    await Future.delayed(const Duration(milliseconds: 500));
    await _cameraController!.startImageStream(_analyzeImage);

    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    setState(() {});
  }

  Future<void> _analyzeImage(CameraImage image) async {
    if (_isDetecting || _faceDetector == null) return;
    _isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isEmpty) {
        emotionLabel = "No face detected";
        emoji = "❓";
      } else {
        final smile = faces.first.smilingProbability ?? 0;
        if (smile > 0.8) {
          emotionLabel = "Happy";
          emoji = "😄";
        } else if (smile > 0.3) {
          emotionLabel = "Neutral";
          emoji = "🙂";
        } else {
          emotionLabel = "Sad";
          emoji = "☹️";
        }
      }

      setState(() {});
    } catch (_) {
      emotionLabel = "Error";
      emoji = "⚠️";
      setState(() {});
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> _endCall() async {
    await FirebaseFirestore.instance
        .collection("calls")
        .doc(widget.patientName.replaceAll(' ', '_'))
        .update({"isActive": false});
    jitsiMeet.hangUp();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector?.close();
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _cameraController != null && _cameraController!.value.isInitialized;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCaller ? "Calling Caregiver" : "Waiting for Caregiver"),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isReady)
            AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(child: CircularProgressIndicator()),
          Positioned(
            top: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Emotion: $emotionLabel",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    backgroundColor: Colors.black54,
                  ),
                ),
                Text(emoji, style: const TextStyle(fontSize: 40)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

