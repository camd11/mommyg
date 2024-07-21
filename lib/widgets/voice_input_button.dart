import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class VoiceInputButton extends StatefulWidget {
  final Function(String) onSpeechResult;

  VoiceInputButton({required this.onSpeechResult});

  @override
  _VoiceInputButtonState createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isAvailable = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void _initSpeech() async {
    _isAvailable = await _speech.initialize(
      onStatus: (status) {
        print('onStatus: $status');
        if (status == 'done') {
          setState(() => _isListening = false);
          _animationController.reverse();
        }
      },
      onError: (errorNotification) {
        print('onError: $errorNotification');
        setState(() => _isListening = false);
        _animationController.reverse();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${errorNotification.errorMsg}')),
        );
      },
    );
    setState(() {});
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is required for voice input.')),
      );
    }
  }

  void _listen() async {
    await _requestPermission();
    if (!_isListening) {
      if (_isAvailable) {
        setState(() => _isListening = true);
        _animationController.forward();
        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              widget.onSpeechResult(result.recognizedWords);
              setState(() => _isListening = false);
              _animationController.reverse();
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech recognition is not available on this device.')),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _listen,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: 48 + (_animationController.value * 24),
            height: 48 + (_animationController.value * 24),
            decoration: BoxDecoration(
              color: _isListening ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.grey,
              size: 24 + (_animationController.value * 8),
            ),
          );
        },
      ),
    );
  }
}