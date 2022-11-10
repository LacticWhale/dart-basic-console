import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Creates [Console] class.
class Console {
  Console({ 
    required this.stdin,
    required this.stdout,
    this.prompt = '',
  });

  /// Input stream.
  final Stdin stdin;
  /// Output stream.
  final Stdout stdout;
  /// Prompt.
  final String prompt;

  final StreamController<String> _lineController = StreamController();
  
  /// Stream of input lines.
  Stream<String> get onLine => _lineController.stream;

  String _buffer = '';

  bool _enabled = false;

  /// Prints message to terminal without interrupting input.
  void log(Object message) {
    stdout.write('\x1B[s\x1B[0G\x1B[0K$message\n\x1B[0G$prompt$_buffer\x1B[u\x1B[B');
  }

  /// Changes how terminal works.
  void enable() {
    if(_enabled)
      return;
    _enabled = true;

    stdout
      ..encoding = utf8
      ..write(prompt);
    stdin
      ..echoMode = false
      ..lineMode = false
      ..listen((char) {
        if(char.first == 13) {
          _lineController.sink.add(_buffer);
          _buffer = '';
          stdout.write('\x1b[E$prompt');
          return;
        } else if(char.first == 8) {
          if(_buffer.isEmpty)
            return;
          _buffer = _buffer.substring(0, _buffer.length - 1);
          stdout.write('\x1b[D \x1b[1D');
          return;
        }
        stdout.add(char);
        _buffer += utf8.decode(char);
      });
  }

  /// Returns terminal to normal state.
  Future<void> close() async {
    if(!_enabled)
      return;
    _enabled = false;
    
    await _lineController.close();
  }
}
