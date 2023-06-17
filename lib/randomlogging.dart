import 'package:logging/logging.dart';

final _logger = Logger('MyClassNameOrFileName');

void someMethod() {
  _logger.info('This is an info message');
  _logger.warning('This is a warning');
  _logger.severe('This is an error');
}

