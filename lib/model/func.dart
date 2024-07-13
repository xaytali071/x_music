import 'dart:io';

void main() async {
  print('YouTube video URL manzilini kiriting:');
  String? youtubeUrl = stdin.readLineSync();

  if (youtubeUrl == null || youtubeUrl.isEmpty) {
    print('YouTube URL manzili kiritilmagan.');
    return;
  }

  print('Saqlanadigan fayl nomini kiriting (default: output.mp3):');
  String? outputPath = stdin.readLineSync();

  outputPath = outputPath != null && outputPath.isNotEmpty ? outputPath : 'output.mp3';

  await downloadAudio(youtubeUrl, outputPath);
}

Future<void> downloadAudio(String youtubeUrl, String outputPath) async {
  var result = await Process.run(
    'python3',
    ['youtube_audio_download.py', youtubeUrl, outputPath],
  );

  if (result.exitCode == 0) {
    print(result.stdout);
  } else {
    print('Xatolik yuz berdi: ${result.stderr}');
  }
}

