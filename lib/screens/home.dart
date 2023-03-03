import 'package:flutter/material.dart';
import 'package:video_quality/widgets/video_player_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('screen'),
      ),
      body: const VideoPlayerWidget(
        url:
            'https://moctobpltc-i.akamaihd.net/hls/live/571329/eight/playlist.m3u8',
      ),
    );
  }
}
