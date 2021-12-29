import 'package:flutter/material.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/ui/widgets/home/story_card.dart';
import 'package:jamii_check/ui/widgets/search/search_filter_bottom_sheet.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:provider/provider.dart';

class SearchStoryWidget extends StatelessWidget {
  final bool? isViewScrollable;
  final List<Story>? stories;
  const SearchStoryWidget({Key? key, this.isViewScrollable, this.stories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Search result for \"${Provider.of<SearchProvider>(context).searchText}\" (${stories!.length} stories)',
                  style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (c) =>SearchFilterBottomSheet()),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color:JAMII_PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: Theme.of(context).hintColor),
                  ),
                  child: Row(children: [
                    Image.asset("assets/images/filter.png", width: 10, height: 10, color: Colors.white),
                    const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    const Text('Filter',style:TextStyle(color: Colors.white)),
                  ]),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: stories!.length,
              //shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return StoryCard(story: stories![index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
