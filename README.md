## Features

* Non-blocking input.
* Non-interrupting output.

## Usage

```dart
import 'dart:io';

import 'package:basic_console/console.dart';

final console = Console(stdin: stdin, stdout: stdout, prompt: '> ')..enable();

void main() {
  console.onLine.listen((line) {
    console.log('Non-interrupting message to console! Echo: $line');
  });
}
```

## Additional information

For utf-8 support on Windows enable it in setting!

## License

* MIT License
