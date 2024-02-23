import 'package:flutter/material.dart';
import 'package:thakeren/Constant/Colors.dart';


class AthkarPage extends StatefulWidget {
  const AthkarPage({super.key});

  @override
  State<AthkarPage> createState() => _AthkarPageState();
}

class _AthkarPageState extends State<AthkarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorsPal.G1),
      body: Column(
        children: [
          SizedBox(),
          Center(
            child: MaterialButton(
              color: Colors.green,
              onPressed: () {},
              child: Text('Get Single Adhkar'),
            ),
          )
        ],
      ),
    );
  }

}
