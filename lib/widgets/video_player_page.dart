import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'url_parser.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller = VideoPlayerController.network('');
  late List<VideoQuality> _videoQualities = [];
  VideoQuality? _selectedVideoQuality;

  @override
  void initState() {
    super.initState();
    _fetchMediaUrls();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchMediaUrls() async {
    final baseUri = Uri.parse(widget.url);
    List<String> mediaUrls = await parseM3u8File(widget.url);

    final uniqueUrls = mediaUrls.toSet().toList(); // Remove duplicates

    _videoQualities = uniqueUrls.map((url) {
      final parts = url.split('|');
      final quality = parts[0];
      final mediaUrl = parts[1];

      final uri = Uri.parse(mediaUrl);
      final absoluteUri =
          uri.isAbsolute ? uri : baseUri.resolve(uri.toString());
      return VideoQuality(quality: quality, url: absoluteUri.toString());
    }).toList();

    setState(() {
      if (_videoQualities.isNotEmpty) {
        _selectedVideoQuality = _videoQualities[0];
        _controller = VideoPlayerController.network(_selectedVideoQuality!.url)
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        DropdownButton(
          value: _selectedVideoQuality,
          items: _videoQualities
              .map<DropdownMenuItem<VideoQuality>>((VideoQuality videoQuality) {
            return DropdownMenuItem<VideoQuality>(
              value: videoQuality,
              child: Text(videoQuality.quality),
            );
          }).toList(),
          onChanged: (VideoQuality? newVideoQuality) async {
            if (newVideoQuality == null) return;
            setState(() {
              _selectedVideoQuality = newVideoQuality;
              _controller.pause();
            });
            await _controller.dispose();
            _controller =
                VideoPlayerController.network(_selectedVideoQuality!.url);
            await _controller.initialize();
            setState(() {
              _controller.play();
            });
          },
        ),
      ],
    );
  }
}

class VideoQuality {
  final String quality;
  final String url;

  VideoQuality({required this.quality, required this.url});
}
