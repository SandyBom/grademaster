import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(TrialMaterial());
}

class TrialMaterial extends StatelessWidget {
  static const nameRoute = '/trialmaterial';
  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/details/:id1/:id2/:id3',
          builder: (context, state) {
            final String id1 = state.pathParameters['id1']!;
            final String id2 = state.pathParameters['id2']!;
            final String id3 = state.pathParameters['id3']!;
            return DetailPage(id1: id1, id2: id2, id3: id3);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Demo(),
        ),
        GoRoute(
          path: '/details/:id1/:id2/:id3',
          builder: (context, state) {
            final String id1 = state.pathParameters['id1']!;
            final String id2 = state.pathParameters['id2']!;
            final String id3 = state.pathParameters['id3']!;
            return DetailPage(id1: id1, id2: id2, id3: id3);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class Demo extends StatelessWidget {
  // Daftar ID yang ingin ditampilkan
  final List<List<String>> ids = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['10', '11', '12'],
    ['10', '', ''],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ListView.builder(
          itemCount: ids.length,
          itemBuilder: (context, index) {
            return CustomButton(ids[index]);
          },
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final List<String> ids;

  CustomButton(this.ids);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigasi ke halaman detail dengan ID yang diberikan
        context.go('/details/${ids[0]}/${ids[1]}/${ids[2]}');
      },
      child: Text('Go to Details with IDs ${ids.join(', ')}'),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String id1;
  final String id2;
  final String id3;

  DetailPage({required this.id1, required this.id2, required this.id3});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail for item ID 1: $id1'),
            Text('Detail for item ID 2: $id2'),
            Text('Detail for item ID 3: $id3'),
          ],
        ),
      ),
    );
  }
}
