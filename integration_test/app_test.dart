import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:getx_ecommerce/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Normal Integration Test - App starts successfully', (tester) async {

    app.main();
    
    //load
    await tester.pumpAndSettle();

    // only check material
    expect(find.byType(MaterialApp), findsWidgets);
  });
}
