
import 'package:flutter_test/flutter_test.dart';
import 'package:play_wave/main.dart';

void main() {
  testWidgets('Halaman utama PlayWave tampil', (tester) async {
    await tester.pumpWidget(const PlayWaveApp());

    expect(find.text('PlayWave'), findsOneWidget);
    expect(find.text('Pilih Gambar'), findsOneWidget);
    expect(find.text('Audio Player'), findsOneWidget);
    expect(find.text('YouTube Video'), findsOneWidget);
  });
}
