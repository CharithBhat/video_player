import 'package:http/http.dart' as http;

Future<List<String>> parseM3u8File(String url) async {
  final response = await http.get(Uri.parse(url));
  final List<String> mediaUrls = [];
  if (response.statusCode == 200) {
    final String body = response.body;
    final List<String> lines = body.split('\n');
    for (String line in lines) {
      if (line.startsWith('#EXT-X-STREAM-INF')) {
        final String resolution = line.split('RESOLUTION=')[1].split(',')[0];
        final String mediaUrl = lines[lines.indexOf(line) + 1];
        mediaUrls.add('$resolution|$mediaUrl');
      } else if (line.isNotEmpty && !line.startsWith('#')) {
        mediaUrls.add('quality|$line');
      }
    }
  }
  // print('Media URLs: $mediaUrls');
  return mediaUrls;
}
