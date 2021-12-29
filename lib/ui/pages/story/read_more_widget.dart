import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadMore extends StatelessWidget {
  final Story? story;
  const ReadMore({Key? key, @required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:story!.inHeadlines?
                              const Color(0xFFF9E2AC): story!.isFaked!
          ? JAMII_RED_COLOR.withOpacity(0.4)
          :const Color(0xFFC6FFD9),
      //padding: const EdgeInsets.symmetric(vertical:5,horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 5),
            child: Text(
              "Verified Story",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:story!.inHeadlines?
                              const Color(0xFFFDB917): story!.isFaked! ? JAMII_RED_COLOR : const Color(0xFF12B347),
                  fontSize: 15),
            ),
          ),
          Divider(
            thickness: 1,
            endIndent: 30,
            indent: 30,
            color:story!.inHeadlines?
                              const Color(0xFFFDB917): story!.isFaked! ? JAMII_RED_COLOR : JAMII_GREEN_COLOR,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: ReadMoreText(
              story!.content!,
              style:const TextStyle(color: Color(0xFF65676A),height: 2.09,fontFamily:"Ubuntu",fontWeight: FontWeight.w300),
              trimLines: 3,
              colorClickableText: Colors.red,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'See More \u2193',
              trimExpandedText: 'See Less \u2191',
              lessStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:story!.inHeadlines?
                              const Color(0xFFFDB917): story!.isFaked! ? JAMII_RED_COLOR : JAMII_GREEN_COLOR),
              moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:story!.inHeadlines?
                              const Color(0xFFFDB917): story!.isFaked! ? JAMII_RED_COLOR : JAMII_GREEN_COLOR),
            ),
          ),
          Container(
            color:story!.inHeadlines?
                              const Color(0xFFB0975A): story!.isFaked!
                ? JAMII_RED_COLOR.withAlpha(150)
                : JAMII_GREEN_COLOR.withAlpha(150),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.link,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                        child: const Text(
                          "Source URL",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          launch(story!.sourceUrl!, forceWebView: true);
                        }),
                  ],
                ),
                const Text("Verified by JF Team AI",style: TextStyle(color: Color(0xFF65676A)),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
