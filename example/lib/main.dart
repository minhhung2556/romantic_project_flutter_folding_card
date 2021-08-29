import 'package:flutter/material.dart';
import 'package:flutter_folding_card/flutter_folding_card.dart';

void main() => runApp(MyApp());

const _kImageUrls = [
  "https://scontent-hkg4-1.xx.fbcdn.net/v/t1.6435-9/240669493_3093165274342302_7696944317595605164_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=730e14&_nc_ohc=QRmRTo3bJOQAX_u8ELe&_nc_ht=scontent-hkg4-1.xx&oh=374ca65aaff7a46dfd4d2f14aff72b11&oe=614F64BC",
  "https://scontent-hkg4-2.xx.fbcdn.net/v/t1.6435-9/240758821_3092745557717607_1758983175902930666_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=730e14&_nc_ohc=z0srgae32A4AX_oURvc&_nc_ht=scontent-hkg4-2.xx&oh=e981297264aca64a25aaf285259f41d7&oe=614CDEA1",
  "https://scontent-hkg4-1.xx.fbcdn.net/v/t1.6435-9/240624734_3092487924410037_2111143168440995076_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=730e14&_nc_ohc=TZukbOFjxowAX8IYthH&_nc_ht=scontent-hkg4-1.xx&oh=59dd511589b6dbdea97a3b478b5d629f&oe=614D9448",
  "https://scontent-hkg4-1.xx.fbcdn.net/v/t1.6435-9/s640x640/237446804_3091585131166983_1116147550483070313_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=8bfeb9&_nc_ohc=5QCW7JFNQoAAX-Suuyv&_nc_ht=scontent-hkg4-1.xx&oh=ca4d078c57e9b95815d6facb38bef7db&oe=614C87E3",
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final itemCount = 5;
  final foldOutList = <bool>[false, false, false, false, false];

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
              child: FoldingPage(
                foldOut: foldOutList[index],
                curve: foldOutList[index] == false
                    ? Curves.easeInCubic
                    : Curves.easeOutCubic,
                duration: Duration(milliseconds: 600),
                pageBackground: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    setState(() {
                      foldOutList[index] = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Text('asd adf asdfa sdf'),
                  ),
                ),
                listener: (value, status) {
                  //TODO
                },
                expandedChild: Image.network(
                  _kImageUrls[1],
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                ),
                cover: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    setState(() {
                      foldOutList[index] = false;
                    });
                  },
                  child: Image.network(
                    _kImageUrls[2],
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topCenter,
                  ),
                ),
                foldingHeight: 100,
                expandedHeight: 450,
              ),
            );
          },
          itemCount: itemCount,
        ),
      ),
    );
  }
}
