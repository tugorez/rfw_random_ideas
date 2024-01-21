import 'package:meta/meta.dart';

typedef DynamicMap = Map<String, Object>;

ArgsReference args(List<String> parts) => ArgsReference(parts);

final class ArgsReference {
  ArgsReference(this.parts);

  final List<String> parts;
}

/// This class is equivalent to a widget declaration.
abstract class RemoteWidget {
  RemoteWidget(this.args);

  /// Any arguments this widget gets passed by its parent.
  final DynamicMap args;

  /// In a widget declaration, this is the rhs.
  /// In 'widget Foo = Container();', this is going to be 'Container()'.
  RemoteWidget? build();

  /// The widget class name will be used as rfw widget name;
  /// In 'widget Foo = Container()' this will be 'Foo'.
  String get _name => runtimeType.toString();
}

@sealed
final class LocalWidget extends RemoteWidget {
  LocalWidget({required String inLibrary})
      : _localLibrary = inLibrary,
        super({});

  /// Which local library is the widget coming from?
  /// in "import core;' this is 'core'.
  final String _localLibrary;

  @override
  RemoteWidget? build() {
    return null;
  }
}

String generateRfwTxt(RemoteWidget widget) {
  final String libraries =
      _findAllLocalWidgets(widget).map(_encodeLibrary).join('\n');
  final String widgetDeclarations =
      _findAllRemoteWidgets(widget).values.map(_encodeWidget).join('\n');
  return [libraries, widgetDeclarations].join('\n');
}

String _encodeLibrary(String library) => 'import $library;';

String _encodeWidget(RemoteWidget widget) {
  final RemoteWidget child = widget.build()!;
  final String childName = child._name;
  final String childArgs = _encodeArgs(child.args);
  return 'widget ${widget._name} = $childName($childArgs);';
}

String _encodeArgs(DynamicMap args) {
  final List<String> buffer = <String>[];
  for (var entry in args.entries) {
    final key = entry.key;
    final val = entry.value;
    if (val is double || val is int) {
      buffer.add('$key: $val');
    } else if (val is String) {
      buffer.add('$key: "$val"');
    } else if (val is RemoteWidget) {
      final widgetName = val._name;
      final widgetArgs = _encodeArgs(val.args);
      buffer.add('$key: $widgetName($widgetArgs)');
    } else if (val is ArgsReference) {
      final path = ['args', ...val.parts].join('.');
      buffer.add('$key: $path');
    } else {
      // Argument not supported.
    }
  }
  return buffer.join(', ');
}

Map<Type, RemoteWidget> _findAllRemoteWidgets(RemoteWidget widget) {
  final Map<Type, RemoteWidget> result = <Type, RemoteWidget>{};
  final RemoteWidget? child = widget.build();
  if (child == null || child is LocalWidget) return result;

  result[widget.runtimeType] = widget;
  result.addAll(_findAllRemoteWidgets(child));
  for (var value in child.args.values) {
    if (value is! RemoteWidget) continue;
    result.addAll(_findAllRemoteWidgets(value));
  }
  return result;
}

Set<String> _findAllLocalWidgets(RemoteWidget widget) {
  if (widget is LocalWidget) return <String>{widget._localLibrary};
  final Set<String> result = <String>{};
  final RemoteWidget child = widget.build()!;
  result.addAll(_findAllLocalWidgets(child));
  for (var value in child.args.values) {
    if (value is! RemoteWidget) continue;
    result.addAll(_findAllLocalWidgets(value));
  }
  return result;
}
