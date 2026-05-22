import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astro_gallery/main.dart';

void main() {
  testWidgets('should show the app title on the home screen', (
    WidgetTester tester,
  ) async {
    //Find
    await tester.pumpWidget(const AstroGalleryApp());

    //Verify
    expect(find.text('Astro Gallery'), findsOneWidget);
  });

  testWidgets('should show the Astronomy Picture of the Day button', (
    WidgetTester tester,
  ) async {
    //Find
    await tester.pumpWidget(const AstroGalleryApp());

    //Verify
    expect(find.text('Astronomy Picture of the Day'), findsOneWidget);
  });

  testWidgets('should show the NASA Photo and Video Library button', (
    WidgetTester tester,
  ) async {
    //Find
    await tester.pumpWidget(const AstroGalleryApp());

    //Verify
    expect(find.text('NASA Photo and Video Library'), findsOneWidget);
  });

  testWidgets('should show two buttons on the home screen', (
    WidgetTester tester,
  ) async {
    //Find
    await tester.pumpWidget(const AstroGalleryApp());

    //Verify
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}
