import 'package:flutter/material.dart';
import 'package:rfw/formats.dart' show parseLibraryFile;
import 'package:rfw/rfw.dart';
import 'main_library.dart';

class App extends StatelessWidget {
  late final _data = DynamicContent();

  late final _runtime = Runtime()
    ..update(const LibraryName(['core']), createCoreWidgets())
    ..update(const LibraryName(['material']), createMaterialWidgets())
    ..update(const LibraryName(['main']), parseLibraryFile(mainLibrary));

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RemoteWidget(
          data: _data,
          runtime: _runtime,
          widget: const FullyQualifiedWidgetName(LibraryName(['main']), 'Main'),
        ),
      ),
    );
  }
}
