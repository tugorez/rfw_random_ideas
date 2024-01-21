const mainLibrary = '''
  import core;
  import material;

  widget Main = CenteredAndBlue(
    text: 'Hello world',
  );

  widget CenteredAndBlue = BlueContainer(
    child: CenteredText(text: args.text),
  );

  widget BlueContainer = Container(
    color: 0xFF78909C,
    child: args.child,
  );

  widget CenteredText = Center(
    child: Text(text: args.text),
  );
''';
