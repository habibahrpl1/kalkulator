
import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator_coba/main.dart'; // Sesuaikan dengan path file Anda

void main() {
  testWidgets('Kalkulator works correctly', (WidgetTester tester) async {
    // Bangun aplikasi dan trigger frame.
    await tester.pumpWidget(MyApp());

    // Verifikasi tampilan awal.
    expect(find.text('0'), findsOneWidget);

    // Tekan tombol '1' dan '2'.
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();

    // Verifikasi bahwa output menjadi '12'.
    expect(find.text('12'), findsOneWidget);

    // Tekan tombol '+'.
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tekan tombol '3'.
    await tester.tap(find.text('3'));
    await tester.pump();

    // Tekan tombol '='.
    await tester.tap(find.text('='));
    await tester.pump();

    // Verifikasi bahwa hasilnya adalah '15'.
    expect(find.text('15'), findsOneWidget);

    // Tekan tombol 'C' untuk membersihkan kalkulator.
    await tester.tap(find.text('C'));
    await tester.pump();

    // Verifikasi tampilan kembali ke '0'.
    expect(find.text('0'), findsOneWidget);
  });
}
