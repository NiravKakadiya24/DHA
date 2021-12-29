import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/story_model.dart';

class FactMark extends StatelessWidget {
  final Story? story;
  const FactMark({Key? key,@required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center, // set transform origin
      transform:  Matrix4.rotationZ(-0.374533),
      child: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: FDottedLine(
                color:story!.inHeadlines?
                              const Color(0xFFFDB917):story!.isFaked!?JAMII_RED_COLOR:JAMII_GREEN_COLOR,
                strokeWidth: 10.0,
                dottedLength: 2.0,
                space: 3.0,
                corner: FDottedLineCorner.all(75.0),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.white,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  height: 15,
                  color:story!.inHeadlines?
                              const Color(0xFFFDB917):story!.isFaked!?JAMII_RED_COLOR:JAMII_GREEN_COLOR,
                  alignment: Alignment.center,
                  child: Text(story!.inHeadlines?
                              "JUST IN":story!.isFaked!?"FAKE":"FACT",style: const TextStyle(color: Colors.white,fontSize: 12),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
