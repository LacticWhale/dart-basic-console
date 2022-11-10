import 'dart:async';
import 'dart:io';

import 'package:basic_console/console.dart';

final console = Console(stdin: stdin, stdout: stdout, prompt: '> ')..enable();

void main() {
  Timer.periodic(const Duration(seconds: 2), (timer) {
    console.log('Async message.');
  });

  console.onLine.listen((event) {
    console.log('New line: $event');
  });
}
