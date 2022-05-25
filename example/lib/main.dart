import 'package:flutter/material.dart';
import 'package:flutter_folding_card/flutter_folding_card.dart';

void main() => runApp(MyApp());

const _kImageUrls = [
  "assets/sample_1.jpg",
  "assets/sample_2.jpg",
  "assets/sample_3.jpg",
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final itemCount = 3;
  final foldOutList = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Example'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  for (var i = 0; i < foldOutList.length; ++i) {
                    foldOutList[i] = false;
                  }
                });
              },
              icon: Icon(Icons.cleaning_services_sharp),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 22),
              child: FoldingCard(
                foldOut: foldOutList[index],
                curve: foldOutList[index] == true
                    ? Curves.easeInCubic
                    : Curves.easeOutCubic,
                duration: Duration(milliseconds: 1400),
                coverBackground: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      foldOutList[index] = true;
                    });
                  },
                  child: Text(
                    'This is a sample coverBackground, click on it to fold in.',
                    textAlign: TextAlign.center,
                  ),
                ),
                expandedCard: index == 1
                    ? Stack(
                        children: [
                          Image.asset(
                            _kImageUrls[0],
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topCenter,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'This is a other sample for expandedCard.',
                              ),
                            ),
                          )
                        ],
                      )
                    : Image.asset(
                        _kImageUrls[1],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                      ),
                cover: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    setState(() {
                      foldOutList[index] = false;
                    });
                  },
                  child: Image.asset(
                    _kImageUrls[2],
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topCenter,
                  ),
                ),
                foldingHeight: 100,
                expandedHeight: 300,
              ),
            );
          },
          itemCount: itemCount,
        ),
      ),
    );
  }
}
