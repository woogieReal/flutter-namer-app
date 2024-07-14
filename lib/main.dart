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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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
}

class MyHomePage extends StatelessWidget {
  /*
  모든 위젯은 위젯이 항상 최신 상태로 유지되도록 위젯의 상황이 변경될 때마다 자동으로 호출되는 build() 메서드를 정의합니다.
  */
  @override
  Widget build(BuildContext context) {

    /*
    MyHomePage는 watch 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적합니다.
    */
    var appState = context.watch<MyAppState>();

    /*
    모든 build 메서드는 위젯 또는 중첩된 위젯 트리(좀 더 일반적임)를 반환해야 합니다.
    여기서 최상위 위젯은 Scaffold입니다.
    이 Codelab에서는 Scaffold를 사용하지 않지만 유용한 위젯이며 대부분의 실제 Flutter 앱에서 찾을 수 있습니다.
    */
    return Scaffold(
      /*
      Column은 Flutter에서 가장 기본적인 레이아웃 위젯 중 하나입니다.
      하위 요소를 원하는 대로 사용하고 이를 위에서 아래로 열에 배치합니다.
      기본적으로 열은 시각적으로 하위 요소를 상단에 배치합니다.
      열이 중앙에 위치하도록 이를 곧 변경합니다.
      */
      body: Column(
        children: [
          Text('A random AWESOME idea:'),
          /*
          이 두 번째 Text 위젯은 appState를 사용하고 해당 클래스의 유일한 멤버인 current(즉, WordPair)에 액세스합니다.
          WordPair는 asPascalCase 또는 asSnakeCase 등 여러 유용한 getter를 제공합니다.
          여기서는 asLowerCase를 사용하지만 대안 중 하나가 더 좋다면 지금 변경해도 됩니다.
          */
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ],
        /*
        Flutter 코드에서는 후행 쉼표를 많이 사용합니다.
        이 특정 쉼표는 여기 없어도 됩니다.
        children이 이 특정 Column 매개변수 목록의 마지막 멤버이자 유일한 멤버이기 때문입니다.
        그러나 일반적으로 후행 쉼표를 사용하는 것이 좋습니다.
        멤버를 더 추가하는 작업이 쉬워지고 Dart의 자동 형식 지정 도구에서 줄바꿈을 추가하도록 힌트 역할을 합니다.
        자세한 내용은 코드 형식 지정을 참고하세요.
        */
      ),
    );
  }
}
