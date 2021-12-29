import 'package:flutter/material.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/custom_button.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:provider/provider.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({Key? key}) : super(key: key);

  @override
  _SearchFilterBottomSheetState createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  void applyFilters(BuildContext context) async {
    Provider.of<SearchProvider>(context, listen: false).sortSearchList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Expanded(child: Text("Sort filters", style: titilliumBold)),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.cancel, color: Colors.red),
          )
        ]),
        Divider(),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Consumer<SearchProvider>(
          builder: (context, search, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sort by",
                style: titilliumSemiBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Theme.of(context).hintColor),
              ),
              Text("Title",
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL)),
              Row(children: [
                Expanded(
                    child: MyCheckBox(title: "Alphabetically ↑", index: 0)),
                Expanded(
                    child: MyCheckBox(title: "Alphabetically ↓", index: 1)),
              ]),
              Text("Date",
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL)),
              Row(children: [
                Expanded(
                    child: MyCheckBox(title: "Alphabetically ↑", index: 2)),
                Expanded(
                    child: MyCheckBox(title: "Alphabetically ↓", index: 3)),
              ]),
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(
                  buttonText: "Apply",
                  onTap: applyFilters,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final String? title;
  final int? index;
  MyCheckBox({@required this.title, @required this.index});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title!,
          style:
              titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
      checkColor: Theme.of(context).primaryColor,
      activeColor: Colors.transparent,
      value: Provider.of<SearchProvider>(context).filterIndex == index,
      onChanged: (isChecked) {
        if (isChecked!) {
          Provider.of<SearchProvider>(context, listen: false)
              .setFilterIndex(index!);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
