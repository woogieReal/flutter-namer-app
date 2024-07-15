import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  /*
  파일 최상단에는 main() 함수가 있습니다.
  현재 형식으로는 MyApp에서 정의된 앱을 실행하라고 Flutter에 지시할 뿐입니다.
  */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /*
  MyApp 클래스는 StatelessWidget을 확장합니다.
  위젯은 모든 Flutter 앱을 빌드하는 데 사용되는 요소입니다.
  앱 자체도 위젯인 것을 확인할 수 있습니다.
  참고: 나중에 StatelessWidget과 StatefulWidget을 비교하여 설명합니다.

  MyApp의 코드는 전체 앱을 설정합니다.
  앱 전체 상태를 생성하고(나중에 자세히 설명) 앱의 이름을 지정하고 시각적 테마를 정의하고 '홈' 위젯(앱의 시작점)을 설정합니다.
  */
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 22, 119, 26)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  /*
  MyAppState 클래스는 앱의 상태를 정의합니다.
  이번이 처음으로 Flutter를 사용하는 것이므로 이 Codelab에서는 코드를 간단하고 명확하게 유지합니다.
  Flutter에는 앱 상태를 관리하는 강력한 방법이 여러 가지 있습니다.
  설명하기 가장 쉬운 것 중 하나는 이 앱에서 사용하는 접근 방식인 ChangeNotifier입니다.

  MyAppState는 앱이 작동하는 데 필요한 데이터를 정의합니다.
  지금은 현재 임의의 단어 쌍이 있는 단일 변수만 포함되어 있습니다.
  나중에 더 추가합니다.
  
  상태 클래스는 ChangeNotifier를 확장합니다.
  즉, 자체 변경사항에 관해 다른 항목에 알릴 수 있습니다.
  예를 들어 현재 단어 쌍이 변경되면 앱의 일부 위젯이 알아야 합니다.

  상태가 만들어지고 ChangeNotifierProvider를 사용하여 전체 앱에 제공됩니다(위의 MyApp 코드 참고).
  이렇게 하면 앱의 위젯이 상태를 알 수 있습니다.
  */
  var current = WordPair.random();

  /*
  새 getNext() 메서드는 임의의 새 WordPair를 current에 재할당합니다.
  또한 MyAppState를 보고 있는 사람에게 알림을 보내는 notifyListeners()(ChangeNotifier)의 메서드)를 호출합니다.
  이제 남은 작업은 버튼의 콜백에서 getNext 메서드를 호출하는 것입니다.
  */
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  /*
  MyAppState에 새 속성 favorites를 추가했습니다.
  이 속성은 빈 목록([])으로 초기화됩니다.

  또한 제네릭을 사용하여 목록에 <WordPair>[] 단어 쌍만 포함될 수 있다고 지정했습니다.
  이렇게 하면 앱이 더 강력해집니다.
  Dart는 개발자가 WordPair 외 다른 것을 추가하려고 하면 앱을 실행하는 것조차 거부합니다.
  결국 숨겨져 있는 원치 않는 객체(예: null)가 있을 수 없음을 알고 favorites 목록을 사용할 수 있습니다.
  */
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  /*
  모든 위젯은 위젯이 항상 최신 상태로 유지되도록 위젯의 상황이 변경될 때마다 자동으로 호출되는 build() 메서드를 정의합니다.
  */
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      /*
      LayoutBuilder의 builder 콜백은 제약 조건이 변경될 때마다 호출됩니다. 예를 들어 다음과 같은 경우 발생합니다.
      - 사용자가 앱의 창 크기를 조절합니다.
      - 사용자가 휴대전화를 세로 모드에서 가로 모드로 또는 그 반대로 회전합니다.
      - MyHomePage 옆에 있는 일부 위젯의 크기가 커져 MyHomePage의 제약 조건이 작아집니다.
      - 기타 등등

      이제 코드에서 현재 constraints를 쿼리하여 라벨을 표시할지 결정할 수 있습니다. 
      */
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              /*
              SafeArea는 하위 요소가 하드웨어 노치나 상태 표시줄로 가려지지 않도록 합니다.
              이 앱에서 이 위젯은 NavigationRail를 래핑하여 탐색 버튼이 휴대기기 상태 표시줄로 가려지지 않도록 합니다.
              */
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600, // true로 변경 시 라벨이 아이콘 옆에 표시됩니다.
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  /*
                  사용자가 대상 중 하나를 선택할 때 발생하는 작업을 정의합니다.
                  */
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;  
                    });
                  },
                ),
              ),
              /*
              Expanded 위젯은 행과 열에서 대단히 유용합니다.
              이 위젯을 사용하면 일부 하위 요소는 필요한 만큼만 공간을 차지하고(여기서는 NavigationRail) 다른 위젯은 남은 공간을 최대한 차지해야 하는(여기서는 Expanded) 레이아웃을 표현할 수 있습니다.
              Expanded 위젯은 '탐욕스럽다'고 생각하면 됩니다.
              */
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    GeneratorPage watch 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적합니다.
    */
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10), // 공간만 차지하고 자체적으로는 아무것도 렌더링하지 않습니다, 시각적 '간격'을 만들 때 흔히 사용됩니다.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  /*
  BigCard 클래스의 생성자를 정의합니다.
  const 키워드는 이 위젯이 불변임을 나타냅니다.
  super.key는 부모 클래스의 생성자에 키를 전달합니다.
  required this.pair는 pair라는 필수 매개변수를 받아서 클래스의 pair 필드에 할당합니다.
  */
  const BigCard({
    super.key,
    required this.pair,
  });

  /*
  pair라는 이름의 WordPair 타입의 변수를 선언합니다.
  final 키워드는 이 변수가 한 번만 설정될 수 있으며 이후에 변경될 수 없음을 나타냅니다.
  */
  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    /*
    build 메서드는 Flutter 위젯의 핵심 메서드로, 위젯 트리를 생성합니다.
    @override는 이 메서드가 부모 클래스 (StatelessWidget)의 메서드를 재정의하고 있음을 나타냅니다.
    */

    /*
    Theme.of(context)로 앱의 현재 테마를 요청합니다.
    테마의 colorScheme 속성과 동일하도록 카드의 색상을 정의합니다.
    색 구성표에는 여러 색상이 포함되어 있으며 primary가 앱을 정의하는 가장 두드러진 색상입니다.
    */
    final theme = Theme.of(context);

    /*
    theme.textTheme, 을 사용하여 앱의 글꼴 테마에 액세스합니다.
    이 클래스에는 bodyMedium(중간 크기의 표준 텍스트용) 또는 caption(이미지 설명용), headlineLarge(큰 헤드라인용) 등의 멤버가 포함되어 있습니다.

    displayMedium 속성은 디스플레이 텍스트를 위한 큰 스타일입니다.
    여기서 디스플레이라는 단어는 디스플레이 서체와 같은 인쇄상의 의미로 사용됩니다.
    displayMedium 문서에는 '디스플레이 스타일은 짧고 중요한 텍스트용으로 예약되어 있습니다'(여기 사용 사례와 정확히 일치함)라고 나옵니다.

    테마의 displayMedium 속성은 이론적으로 null일 수 있습니다.
    이 앱을 작성하는 데 사용하는 Dart라는 프로그래밍 언어는 null에 안전하므로 null이 될 수 있는 객체의 메서드를 개발자가 호출할 수 없습니다.
    하지만 이 경우 ! 연산자('bang 연산자')를 사용하여 개발자가 잘 알고 하는 작업임을 Dart에 알릴 수 있습니다.
    displayMedium은 이 경우 null이 아닌 것이 분명하지만 그 이유에 관한 내용은 이 Codelab에서 다루지 않습니다.

    displayMedium에서 copyWith()를 호출하면 정의된 변경사항이 포함된 텍스트 스타일의 사본이 반환됩니다.
    여기서는 텍스트의 색상만 변경합니다.

    새로운 색상을 가져오려면 앱의 테마에 다시 액세스해야 합니다.
    색 구성표의 onPrimary 속성은 앱의 기본 색상으로 사용하기 적합한 색상을 정의합니다.

    */
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase, // Text의 semanticsLabel 속성을 사용하여 텍스트 위젯의 시각적 콘텐츠를 스크린 리더에 더 적합한 시맨틱 콘텐츠로 재정의합니다.
        ),
      ),
    );
  }
}
