import 'package:flutter/material.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/helper/utils.dart';
import 'package:jamii_check/models/search_model.dart';
import 'package:jamii_check/ui/pages/story/no_result_screen.dart';
import 'package:jamii_check/ui/pages/story/product_shimmer.dart';
import 'package:jamii_check/ui/widgets/basewidgets/loader/custom_loader.dart';
import 'package:jamii_check/ui/widgets/search/search_story_widget.dart';
import 'package:jamii_check/ui/widgets/search/search_widget.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onTapSearchHistory(Search query) {
    Provider.of<SearchProvider>(context, listen: false)
        .searchStory(query, context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        Provider.of<SearchProvider>(context, listen: false).cleanSearchStory());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: JAMII_PRIMARY_COLOR,
        elevation: 0,
        title: const Text("Search Stories and Topics"),
        centerTitle:true,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SearchWidget(
            hintText: "Search here",
            onSubmit: (text) {
              Search search = Search(
                  id: randomId(),
                  userEmail: globals.jamiiUser.email,
                  value: text,
                  createdAt: DateTime.now().toUtc());
              Provider.of<SearchProvider>(context, listen: false)
                  .searchStory(search, context);
              Provider.of<SearchProvider>(context, listen: false)
                  .saveSearch(search);
            },
            onClearPressed: () {
              //Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
            },
            onTextChanged: (value) {
              debugPrint(value);
            },
          ),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              return !searchProvider.isClear
                  ? searchProvider.searchStoryList != null
                      ? (searchProvider.searchStoryList!.isNotEmpty
                          ? Expanded(
                              child: SearchStoryWidget(
                                  stories: searchProvider.searchStoryList,
                                  isViewScrollable: true))
                          : const Expanded(
                              child:
                                  NoSearchResult()))
                      : const Expanded(
                          child: Center(
                            child: CustomLoader(color: JAMII_PRIMARY_COLOR),
                          ))
                  : Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Consumer<SearchProvider>(
                              builder: (context, searchProvider, child) =>
                                  StaggeredGridView.countBuilder(
                                crossAxisCount: 3,
                                padding: const EdgeInsets.only(
                                    top: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchProvider.historyList.length,
                                itemBuilder: (context, index) => Container(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        Provider.of<SearchProvider>(context,
                                                listen: false)
                                            .searchStory(
                                                searchProvider
                                                    .historyList[index],
                                                context);
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: const Color(0xFFF1F1F1)),
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            Provider.of<SearchProvider>(context,
                                                        listen: false)
                                                    .historyList[index]
                                                    .value ??
                                                "",
                                            style: titilliumItalic.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL),
                                          ),
                                        ),
                                      ),
                                    )),
                                staggeredTileBuilder: (int index) =>
                                    const StaggeredTile.fit(1),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                              ),
                            ),
                            Positioned(
                              top: -5,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Search history",
                                      style: robotoBold),
                                  InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        Provider.of<SearchProvider>(context,
                                                listen: false)
                                            .clearSearchAddress();
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            "remove",
                                            style: titilliumRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
