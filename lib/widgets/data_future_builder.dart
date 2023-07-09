import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
final _logger = Logger('DFB_Logging');

class DataFutureBuilder<T> extends StatelessWidget {
  final Future<List<T>> future;
  final Widget Function(BuildContext, List<T>) dataBuilder;

  const DataFutureBuilder({
    Key? key,
    required this.future,
    required this.dataBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.info('FUTURE_BUILDER');
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        _logger.info("Snapshot state: ${snapshot.connectionState}");
        if (snapshot.hasData) {
          _logger.info("Snapshot data: ${snapshot.data}");
          return dataBuilder(context, snapshot.data!);
        } else if (snapshot.hasError) {
          _logger.info("Snapshot error: ${snapshot.error}");
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },

    );
  }
}
