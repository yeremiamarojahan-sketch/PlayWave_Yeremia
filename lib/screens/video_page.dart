import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController controller;

  final String videoId = 'V9PVRfjEBTI';

  bool sudahSiap = false;
  double kecepatan = 1.0;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  void ubahKecepatan(double nilai) {
    if (!sudahSiap) return;

    controller.setPlaybackRate(nilai);

    setState(() {
      kecepatan = nilai;
    });
  }

  Future<void> bukaYouTube() async {
    final url = Uri.parse('https://youtube.com/watch?v=fKopy74weus&si=fmTLA2rJkE7xaY1J');

    try {
      final berhasil = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!berhasil && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal membuka YouTube')));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.cyanAccent,
        onReady: () {
          if (!mounted) return;

          setState(() {
            sudahSiap = true;
          });
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: const Text('Video Player')),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(12), child: player),

              const SizedBox(height: 20),

              const Text(
                'BIRDS OF A FEATHER - Official Music Video',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                'Billie Eilish',
                style: TextStyle(color: Colors.white60),
              ),

              const SizedBox(height: 22),

              const Text('Kecepatan Pemutaran'),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                children: [1.0, 1.5, 2.0].map((nilai) {
                  return ChoiceChip(
                    label: Text('${nilai}x'),
                    selected: kecepatan == nilai,
                    onSelected: sudahSiap
                        ? (dipilih) {
                            if (dipilih) {
                              ubahKecepatan(nilai);
                            }
                          }
                        : null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              OutlinedButton.icon(
                onPressed: bukaYouTube,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Buka di YouTube'),
              ),
            ],
          ),
        );
      },
    );
  }
}
