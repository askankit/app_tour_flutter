import 'package:app_tour_flutter/app_tour_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _removeKey = GlobalKey();
  final GlobalKey _actionKey = GlobalKey();
  late CustomAppTour _appTour;

  @override
  void initState() {
    _appTour = CustomAppTour(
      context: context,
      steps: [
        TourStep(
          targetKey: _addKey,
          title: 'Add',
          description: 'You can add items here',
        ),
        TourStep(
          targetKey: _removeKey,
          title: 'Remove',
          description: 'You can remove items here',
        ),
        TourStep(
          targetKey: _actionKey,
          title: 'More Option',
          description: 'You want to explore more then click here',
        ),
      ],
    );
    Future.microtask(() => _appTour.startTour());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              key: _addKey,
              onPressed: () {},
              label: Icon(Icons.add_box_outlined),
            ),
            SizedBox(width: 50,),
            ElevatedButton.icon(
              key: _removeKey,
              onPressed: () {},
              label: Icon(Icons.remove_circle),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _actionKey,
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
