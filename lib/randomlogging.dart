import 'package:logging/logging.dart';

final _logger = Logger('MyClassNameOrFileName');

void someMethod() {
  _logger.info('This is an info message');
  _logger.warning('This is a warning');
  _logger.severe('This is an error');
}

//medium post suggesting implementing something like this to improve the debug process, I will probably make when want to extend

/*
final logger = Logger(
  filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
  output: null, // Use the default LogOutput (-> send everything to console)
);


final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: true // Should each log print contain a timestamp  ),
);
*/