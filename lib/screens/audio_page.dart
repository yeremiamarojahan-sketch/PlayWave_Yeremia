
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final AudioPlayer player = AudioPlayer();

  final String audioUrl = 'https://remotion.media/audio.mp3';

  StreamSubscription<void>? selesaiListener;

  bool sedangPutar = false;
  bool sedangMuat = false;
  bool sudahMulai = false;
  bool sudahSelesai = false;
  double kecepatan = 1.0;

  @override
  void initState() {
    super.initState();

    selesaiListener = player.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        sedangPutar = false;
        sudahSelesai = true;
      });
    });
  }

  Future<void> putarAudio() async {
    if (sedangMuat) return;

    setState(() {
      sedangMuat = true;
    });

    try {
      if (!sudahMulai || sudahSelesai) {
        await player.play(UrlSource(audioUrl));
        await player.setPlaybackRate(kecepatan);

        sudahMulai = true;
        sudahSelesai = false;
        sedangPutar = true;
      } else if (sedangPutar) {
        await player.pause();
        sedangPutar = false;
      } else {
        await player.resume();
        sedangPutar = true;
      }
    } catch (e) {
      sedangPutar = false;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio gagal diputar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          sedangMuat = false;
        });
      }
    }
  }

  Future<void> gantiKecepatan(double nilai) async {
    try {
      if (sudahMulai && !sudahSelesai) {
        await player.setPlaybackRate(nilai);
      }

      if (!mounted) return;

      setState(() {
        kecepatan = nilai;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah kecepatan: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    selesaiListener?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF30205B),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.headphones,
                  color: Colors.purpleAccent,
                  size: 100,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Online Music',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Contoh audio streaming',
                style: TextStyle(color: Colors.white60),
              ),

              const SizedBox(height: 24),

              sedangMuat
                  ? const CircularProgressIndicator()
                  : IconButton.filled(
                      onPressed: putarAudio,
                      iconSize: 38,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(16),
                      ),
                      icon: Icon(
                        sedangPutar
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),

              const SizedBox(height: 24),

              const Text('Kecepatan Pemutaran'),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: [1.0, 1.25, 1.5].map((nilai) {
                  return ChoiceChip(
                    label: Text('${nilai}x'),
                    selected: kecepatan == nilai,
                    onSelected: (dipilih) {
                      if (dipilih) gantiKecepatan(nilai);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
