import 'package:flutter/material.dart';
import 'package:video_quality/screens/home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}


// Future<void> _fetchMediaUrls() async {
  //   final mediaUrls = await parseM3u8File(widget.url);
  //   _videoQualities = mediaUrls.map((url) {
  //     final quality = url.split(':')[0];
  //     final mediaUrl = url.split(':')[1];
  //     return VideoQuality(quality: quality, url: mediaUrl);
  //   }).toList();

  //   setState(() {
  //     if (_videoQualities.isNotEmpty) {
  //       _selectedVideoQuality = _videoQualities[0];
  //       _controller = VideoPlayerController.network(_selectedVideoQuality!.url)
  //         ..initialize().then((_) {
  //           setState(() {});
  //           _controller.play();
  //         });
  //     }
  //   });
  // }