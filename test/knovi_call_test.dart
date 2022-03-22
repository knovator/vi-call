import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knovi_call/knovi_call.dart';

void main() {
  const MethodChannel channel = MethodChannel('knovi_call');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });


}
