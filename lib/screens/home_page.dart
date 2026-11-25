
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'audio_page.dart';
import 'video_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker picker = ImagePicker();
  Uint8List? gambar;

  Future<void> pilihGambar() async {
    try {
      final hasil = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (hasil == null) return;

      final data = await hasil.readAsBytes();
      if (!mounted) return;

      setState(() {
        gambar = data;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar: $e')),
      );
    }
  }

  Widget menuMedia(
    IconData ikon,
    String judul,
    String keterangan,
    Widget halaman,
  ) {
    return Card(
      color: const Color(0xFF10233C),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF243252),
          child: Icon(ikon, color: Colors.orangeAccent),
        ),
        title: Text(
          judul,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(keterangan),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => halaman),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayWave'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Media Handling',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Gambar, Audio & Video',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 20),

              Container(
                height: 210,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFF10233C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: gambar == null
                    ? const Icon(
                        Icons.image_outlined,
                        size: 75,
                        color: Colors.purpleAccent,
                      )
                    : Image.memory(
                        gambar!,
                        fit: BoxFit.contain,
                      ),
              ),

              const SizedBox(height: 14),

              FilledButton.icon(
                onPressed: pilihGambar,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pilih Gambar'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                ),
              ),

              const SizedBox(height: 28),

              menuMedia(
                Icons.headphones,
                'Audio Player',
                'Putar audio online',
                const AudioPage(),
              ),

              menuMedia(
                Icons.play_circle_outline,
                'YouTube Video',
                'Putar video dari YouTube',
                const VideoPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
