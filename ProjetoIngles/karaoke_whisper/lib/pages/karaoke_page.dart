import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class KaraokePage extends StatefulWidget {
  final List<dynamic> jsonData;
  final String audioPath;
  final String fullLyrics;

  const KaraokePage({
    super.key,
    required this.jsonData,
    required this.audioPath,
    required this.fullLyrics,
  });

  @override
  State<KaraokePage> createState() => _KaraokePageState();
}

class _KaraokePageState extends State<KaraokePage> {
  final AudioPlayer _player = AudioPlayer();
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAudio();
  }

  void startAudio() async {
    await _player.play(DeviceFileSource(widget.audioPath));

    // Atualiza a linha atual a cada 100ms
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      final pos = await _player.getCurrentPosition();
      if (pos != null) updateCurrentIndex(pos.inMilliseconds.toDouble());
    });

    _player.onPlayerComplete.listen((event) {
      _timer?.cancel();
      setState(() => currentIndex = 0);
    });
  }

  void updateCurrentIndex(double millis) {
    for (int i = 0; i < widget.jsonData.length; i++) {
      final start = widget.jsonData[i]["start"] as double;
      final end = widget.jsonData[i]["end"] as double;
      if (millis >= start && millis <= end) {
        setState(() => currentIndex = i);
        break;
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Karaoke 🎤")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: widget.jsonData.length,
          itemBuilder: (context, index) {
            final line = widget.jsonData[index]["text"];
            final isCurrent = index == currentIndex;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: 18,
                  color: isCurrent ? Colors.amber : Colors.white70,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
