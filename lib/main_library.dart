import 'rfw_in_dart.dart';

final mainLibrary = generateRfwTxt(Main({}));

class Main extends RemoteWidget {
  Main(super.args);

  @override
  RemoteWidget build() {
    return CenteredAndBlue({
      'text': 'Hello world!',
    });
  }
}

class CenteredAndBlue extends RemoteWidget {
  CenteredAndBlue(super.args);

  @override
  RemoteWidget build() {
    return BlueContainer({
      'child': CenteredText({
        'text': args(['text']),
      }),
    });
  }
}

class BlueContainer extends RemoteWidget {
  BlueContainer(super.args);

  @override
  RemoteWidget build() {
    return Container({
      'color': 0xFF78909C,
      'child': args(['child']),
    });
  }
}

class CenteredText extends RemoteWidget {
  CenteredText(super.args);

  @override
  RemoteWidget build() {
    return Center({
      'child': Text({
        'text': args(['text']),
      }),
    });
  }
}

// Local widget definitions.
class Center extends RemoteWidget {
  Center(super.args);

  @override
  RemoteWidget build() {
    return LocalWidget(inLibrary: 'core');
  }
}

class Container extends RemoteWidget {
  Container(super.args);

  @override
  RemoteWidget build() {
    return LocalWidget(inLibrary: 'core');
  }
}

class Text extends RemoteWidget {
  Text(super.args);

  @override
  RemoteWidget build() {
    return LocalWidget(inLibrary: 'core');
  }
}
