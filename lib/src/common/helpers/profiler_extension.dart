import 'package:logger/logger.dart';

/// A class that provides utility methods for metrics and profiling code execution.
class Profiler {
  static String formatTime(int ms) {
    final duration = Duration(milliseconds: ms);
    if (ms < 1000) {
      return '$ms ms';
    } else if (ms < 60000) {
      return '${duration.inSeconds}.${(ms % 1000 / 10).floor()} s';
    } else if (ms < 3600000) {
      return '${duration.inMinutes}.${(duration.inSeconds % 60 / 0.6).floor()} m';
    } else {
      return '${duration.inHours}.${(duration.inMinutes % 60 / 0.6).floor()} h';
    }
  }

  static measureAsync({required String name, required Future Function() f}) async {
    final sw = Stopwatch()..start();
    await f();
    sw.stop();
    Logger().f('$name: ${formatTime(sw.elapsedMilliseconds)}');
  }

  static measureSync(String name, Function() f) {
    final sw = Stopwatch()..start();
    f();
    sw.stop();
    Logger().f('$name: ${formatTime(sw.elapsedMilliseconds)}');
  }
}
